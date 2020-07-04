import 'dart:async';

import 'package:flutter/material.dart';

mixin PeriodicRebuildMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  Timer _rebuildTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _rebuildTimer = _createTimer();
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _rebuildTimer.cancel();
        break;
      case AppLifecycleState.resumed:
        _rebuild();
        _rebuildTimer = _createTimer();
        break;
    }
  }

  Timer _createTimer() =>
      Timer.periodic(Duration(minutes: 1), (_) => _rebuild());

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}
