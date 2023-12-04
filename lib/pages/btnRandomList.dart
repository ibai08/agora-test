import 'package:flutter/material.dart';
import 'package:tredingview_v1/config/const.dart';

class BtnRandomList extends StatefulWidget {
  const BtnRandomList({Key? key}) : super(key: key);

  @override
  State<BtnRandomList> createState() => _BtnRandomListState();
}

class _BtnRandomListState extends State<BtnRandomList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextButton(
              style:
                  TextButton.styleFrom(backgroundColor: ConstColor.accentGreen),
              onPressed: () {
                Navigator.pushNamed(context, '/trading-view-chart');
              },
              child: Text(
                "Trading View Chart",
                style: TextStyle(
                  color: ConstColor.white,
                ),
              ),
            ),
            TextButton(
              style:
                  TextButton.styleFrom(backgroundColor: ConstColor.accentGreen),
              onPressed: () {
                Navigator.pushNamed(context, '/agora-communication');
              },
              child: Text(
                "Agora Communication",
                style: TextStyle(
                  color: ConstColor.white,
                ),
              ),
            ),
            // TextButton(
            //   style:
            //       TextButton.styleFrom(backgroundColor: ConstColor.accentGreen),
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/agora-video-call-accept');
            //   },
            //   child: Text(
            //     "Agora Video Call Accept",
            //     style: TextStyle(
            //       color: ConstColor.white,
            //     ),
            //   ),
            // ),
            TextButton(
              style:
                  TextButton.styleFrom(backgroundColor: ConstColor.accentGreen),
              onPressed: () {
                Navigator.pushNamed(context, '/agora-vc-input-channelname');
              },
              child: Text(
                "Agora Video Call",
                style: TextStyle(
                  color: ConstColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
