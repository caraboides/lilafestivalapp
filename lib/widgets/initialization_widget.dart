import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/event.dart';
import '../models/festival_config.dart';
import '../models/my_schedule.dart';
import '../models/theme.dart';
import '../providers/my_schedule.dart';
import '../providers/provider_module.dart';
import '../providers/schedule.dart';
import '../services/notifications/notifications.dart';
import '../utils/combined_async_values.dart';
import '../utils/logging.dart';
import 'mixins/one_time_execution_mixin.dart';

class InitializationWidget extends StatefulHookConsumerWidget {
  InitializationWidget(this.child);

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InitializationWidgetState();
}

class _InitializationWidgetState extends ConsumerState<InitializationWidget>
    with OneTimeExecutionMixin {
  bool initializedNotifications = false;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Logger get _log => const Logger(module: 'InitializationWidget');

  void _precacheImages(BuildContext context) =>
      Optional.ofNullable(_theme.logoMenu).ifPresent((logo) => precacheImage(
            AssetImage(logo.assetPath),
            context,
            size: logo.size,
          ));

  bool _verifyScheduledNotifications(
    AsyncValue<MySchedule> myScheduleProvider,
    AsyncValue<ImmortalList<Event>> eventProvider,
  ) =>
      combineAsyncValues<void, ImmortalList<Event>, MySchedule>(
          eventProvider, myScheduleProvider, (events, mySchedule) {
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
    final festivalId = _config.festivalId;
    final mySchedule = ref.watch(dimeGet<MyScheduleProvider>()(festivalId));
    final events = ref.watch(dimeGet<ScheduleProvider>()(festivalId));
    executeUntilSuccessful(
        () => _verifyScheduledNotifications(mySchedule, events));
    return widget.child;
  }
}
