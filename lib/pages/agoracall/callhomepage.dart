import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tredingview_v1/appbar/navmain.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tredingview_v1/pages/agoracall/callpage.dart';

class CallHomePage extends StatefulWidget {
  const CallHomePage({Key? key}) : super(key: key);

  @override
  State<CallHomePage> createState() => _CallHomePageState();
}

class _CallHomePageState extends State<CallHomePage> {
  final _channelController = TextEditingController();
  bool _validateError = false;

  int typeRole = 0;
  int uid = 0;
  late RtcEngine agoraEngine;
  final ClientRole? _role = ClientRole.Broadcaster;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavMain(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: <Widget>[
            const SizedBox(height: 40),
            Image.asset("assets/icon/my-logo-text.png"),
            const SizedBox(height: 20),
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                errorText: _validateError ? "Channel Name is mandatory" : null,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                hintText: "Channel Name",
              ),
            ),
            // RadioListTile(
            //   title: const Text("Broadcaster"),
            //   onChanged: (ClientRole? value) {
            //     setState(() {
            //       _role = value;
            //     });
            //   },
            //   value: ClientRole.Broadcaster,
            //   groupValue: _role,
            // ),
            // RadioListTile(
            //   title: const Text("Audience"),
            //   onChanged: (ClientRole? value) {
            //     setState(() {
            //       _role = value;
            //     });
            //   },
            //   value: ClientRole.Audience,
            //   groupValue: _role,
            // ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: onJoin,
              child: const Text("Join"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallPage(
                  channelName: _channelController.text,
                  role: _role,
                )),
      );
    }
  }
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  log(status.toString());
}
