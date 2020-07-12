import 'package:flutter/material.dart';

mixin OneTimeExecutionMixin<T extends StatefulWidget> on State<T> {
  bool _executionPending = true;
  bool _conditionalExecutionPending = true;

  void executeOnce(VoidCallback callback) {
    if (_executionPending) {
      callback();
      _executionPending = false;
    }
  }

  void executeUntilSuccessful(ValueGetter<bool> callback) {
    if (_conditionalExecutionPending) {
      _conditionalExecutionPending = !callback();
    }
  }
}
