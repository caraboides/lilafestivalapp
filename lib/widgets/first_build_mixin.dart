import 'package:flutter/material.dart';

mixin FirstBuildCallbackMixin<T extends StatefulWidget> on State<T> {
  bool _isFirstBuild = true;

  void onFirstBuild(VoidCallback callback) {
    if (_isFirstBuild) {
      callback();
      _isFirstBuild = false;
    }
  }
}
