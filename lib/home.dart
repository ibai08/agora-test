import 'package:flutter/material.dart';
import 'package:tredingview_v1/appbar/navmain.dart';
import 'package:tredingview_v1/config/const.dart';
import 'package:tredingview_v1/pages/btnRandomList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavMain(),
      body: const BtnRandomList(),
      backgroundColor: ConstColor.light,
    );
  }
}
