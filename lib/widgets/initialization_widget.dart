import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/enhanced_event.dart';
import '../models/theme.dart';
import '../providers/combined_schedule.dart';
import '../providers/provider_module.dart';
import '../services/notifications/notifications.dart';
import 'one_time_execution_mixin.dart';

class InitializationWidget extends StatefulHookWidget {
  InitializationWidget(this.child);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _InitializationWidgetState();
}

class _InitializationWidgetState extends State<InitializationWidget>
    with OneTimeExecutionMixin {
  bool initializedNotifications = false;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  void _precacheImages(BuildContext context) {
    if (_theme.logoMenu != null) {
      precacheImage(
        AssetImage(_theme.logoMenu.assetPath),
        context,
        size: Size(_theme.logoMenu.width, _theme.logoMenu.height),
      );
    }
  }

  bool _verifyScheduledNotifications(
    AsyncValue<ImmortalList<EnhancedEvent>> enhancedEvents,
  ) =>
      enhancedEvents.when(
        data: (events) {
          if (events.isNotEmpty) {
            dimeGet<Notifications>().verifyScheduledEventNotifications(events);
          }
          return true;
        },
        loading: () => false,
        // TODO(SF) ERROR HANDLING
        error: (_, __) => false,
      );

  @override
  Widget build(BuildContext context) {
    executeOnce(() {
      _precacheImages(context);
      dimeInstall(ProviderModule(context));
      dimeGet<Notifications>().initializeNotificationPlugin();
    });
    final enhancedEvents = useProvider(dimeGet<CombinedScheduleProvider>());
    executeUntilSuccessful(() => _verifyScheduledNotifications(enhancedEvents));
    return widget.child;
  }
}
