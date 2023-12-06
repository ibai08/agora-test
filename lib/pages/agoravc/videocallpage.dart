import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:permission_handler/permission_handler.dart';
import 'package:tredingview_v1/config/agora.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({
    Key? key,
    required this.channelName,
    this.role,
  }) : super(key: key);

  final String channelName;
  final ClientRole? role;

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    // _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add("APP ID kosong");
        _infoStrings.add("Agora Engine is not Starting");
      });
      return;
    }

    // initAgoraRtcEngine
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role!);

    // addAgoraEventHandlers
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(token, widget.channelName, null, 0);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (err) {
      setState(() {
        final info = "Error: $err";
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = "Join Channel: $channel, uid: $uid";
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add("Leave Channel");
        _users.clear();
      });
    }, userJoined: (uid, elpased) {
      setState(() {
        final info = "User Joined: $uid";
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elpased) {
      setState(() {
        final info = "User Offline: $uid";
        _infoStrings.add(info);
        _users.remove(uid);
        if (_users.length < 2) {
          Navigator.pop(context);
        }
      });
    }, firstRemoteVideoFrame: (uid, width, height, elpased) {
      setState(() {
        final info = "First Remote Video: $uid $width x $height";
        _infoStrings.add(info);
      });
    }));
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(const rtc_local_view.SurfaceView());
    }
    for (var uid in _users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: uid,
        channelId: widget.channelName,
      ));
    }
    final views = list;
    return Column(
      children: List.generate(
        views.length,
        (index) => Expanded(
          child: views[index],
        ),
      ),
    );
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              setState(() {
                muted = !muted;
              });
              _engine.muteLocalAudioStream(muted);
            },
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15),
          ),
          RawMaterialButton(
            onPressed: () => _engine.switchCamera(),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget _panel() {
    return Visibility(
      visible: viewPanel,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: ListView.builder(
                reverse: true,
                itemCount: _infoStrings.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_infoStrings.isEmpty) {
                    return const Text("NULL");
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              _infoStrings[index],
                              style: const TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora VC"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                viewPanel = !viewPanel;
              });
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
