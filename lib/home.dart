import 'package:flutter/material.dart';
import 'package:tredingview_v1/appbar/navmain.dart';
import 'package:tredingview_v1/config/const.dart';
import 'package:tredingview_v1/pages/btnRandomList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavMain(),
      body: const BtnRandomList(),
      backgroundColor: ConstColor.light,
    );
  }
}
