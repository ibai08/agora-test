import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tredingview_v1/config/const.dart';

class NavTxt extends AppBar {
  NavTxt({Key? key, String? title, tap, BuildContext? context})
      : super(
            key: key,
            title: Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
            leading: Transform.translate(
              offset: const Offset(2, 0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.of(context!).pop(),
              ),
            ),
            leadingWidth: 30,
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: ConstColor.white,
            elevation: 2,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: ConstColor.white),
            iconTheme: const IconThemeData(color: Colors.black));

  NavTxt.stream({Key? key, StreamBuilder<String>? title, tap})
      : super(
            key: key,
            title: title,
            centerTitle: true,
            backgroundColor: Colors.white,
            shadowColor: ConstColor.white,
            elevation: 2,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: ConstColor.white),
            iconTheme: const IconThemeData(color: Colors.black));
}
