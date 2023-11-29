import 'package:flutter/material.dart';
import 'package:tredingview_v1/appbar/navmain.dart';

class SymbolList extends StatefulWidget {
  const SymbolList({Key? key}) : super(key: key);

  @override
  State<SymbolList> createState() => _SymbolListState();
}

class _SymbolListState extends State<SymbolList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavMain(),
      body: const Text("asd"),
    );
  }
}
