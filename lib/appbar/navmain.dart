import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tredingview_v1/config/const.dart';

class NavMain extends AppBar {
  NavMain({Key? key, Widget? title})
      : super(
            key: key,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/icon/my-logo.png',
                  width: 90,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            elevation: 2,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: ConstColor.white,
                statusBarIconBrightness: Brightness.dark),
            iconTheme: IconThemeData(color: ConstColor.black),
            centerTitle: true,
            backgroundColor: ConstColor.white,
            shadowColor: ConstColor.white);
}
