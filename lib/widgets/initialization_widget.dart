import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/event.dart';
import '../models/my_schedule.dart';
import '../models/theme.dart';
import '../providers/my_schedule.dart';
import '../providers/provider_module.dart';
import '../providers/schedule.dart';
import '../services/notifications/notifications.dart';
import '../utils/combined_async_value.dart';
import '../utils/logging.dart';
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
  Logger get _log => const Logger('InitializationWidget');

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
    AsyncValue<MySchedule> myScheduleProvider,
    AsyncValue<ImmortalList<Event>> eventProvider,
  ) =>
      combineAsyncValues(eventProvider, myScheduleProvider,
          (events, mySchedule) {
        _log.debug('Verify notifications for liked events');
        dimeGet<Notifications>()
            .verifyScheduledEventNotifications(mySchedule, events);
      }).when(
        data: (_) => true,
        loading: () => false,
        error: (error, trace) {
          _log.error('Error retrieving data, notification verification failed',
              error, trace);
          // TODO(SF) FEATURE recovery?
          return true;
        },
      );

  @override
  Widget build(BuildContext context) {
    executeOnce(() {
      _log.debug('Peform one-time initialization');
      _precacheImages(context);
      dimeInstall(ProviderModule(context));
      dimeGet<Notifications>().initializeNotificationPlugin();
    });
    // TODO(SF) STATE improve
    final mySchedule = useProvider(dimeGet<MyScheduleProvider>().state);
    final events = useProvider(dimeGet<ScheduleProvider>());
    executeUntilSuccessful(
        () => _verifyScheduledNotifications(mySchedule, events));
    return widget.child;
  }
}
