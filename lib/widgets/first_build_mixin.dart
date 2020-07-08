import 'package:flutter/material.dart';

mixin FirstBuildMixin<T extends StatefulWidget> on State<T> {
  bool _isFirstBuild = true;

  void onFirstBuild(VoidCallback callback) {
    if (_isFirstBuild) {
      callback();
      _isFirstBuild = false;
    }
  }
}
