import 'package:flutter/material.dart';
import 'package:tredingview_v1/home.dart';
import 'package:tredingview_v1/pages/agoracall/callhomepage.dart';
import 'package:tredingview_v1/pages/agoracall/callpage.dart';
import 'package:tredingview_v1/pages/agoramessaging/messagepage.dart';
import 'package:tredingview_v1/pages/agoravc/videocallhomepage.dart';
import 'package:tredingview_v1/tradingview/tradingview_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test ALL PUB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/trading-view-chart': (context) => const TradingViewChart(),
        '/agora-vc-input-channelname': (context) => const VideoCallHomePage(),
        '/agora-message': (context) => const MessagePage(),
        '/agora-call-input-channelname': (context) => const CallHomePage(),
      },
      home: const HomeScreen(),
    );
  }
}
