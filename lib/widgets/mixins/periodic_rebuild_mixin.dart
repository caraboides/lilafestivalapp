import 'dart:async';
import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../models/global_config.dart';

// TODO(SF) STATE find better solution? determine next band-playing-change
// or day switch
// > scroll on first build get's obsolete
mixin PeriodicRebuildMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  Timer? _rebuildTimer;

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
        _rebuildTimer?.cancel();
        break;
      case AppLifecycleState.resumed:
        _rebuild();
        _rebuildTimer = _createTimer();
        break;
    }
  }

  Timer _createTimer() => Timer.periodic(
        dimeGet<GlobalConfig>().periodicRebuildDuration,
        (_) => _rebuild(),
      );

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }
}
