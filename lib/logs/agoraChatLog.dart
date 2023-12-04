import 'package:flutter/material.dart';

class AgoraChatLogController extends ValueNotifier<List<String>> {
  AgoraChatLogController() : super([]);

  void addLog(String log) {
    value = [log, ...value];
  }
}
