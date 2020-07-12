import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/event.dart';
import '../models/my_schedule.dart';
import '../providers/my_schedule.dart';
import '../providers/schedule.dart';
import '../services/notifications/notifications.dart';

class InitializationWidget extends StatefulHookWidget {
  InitializationWidget(this.child);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _InitializationWidgetState();
}

class _InitializationWidgetState extends State<InitializationWidget> {
  bool initialized = false;

  ImmortalMap<int, Event> _calculateRequiredNotifications(
      ImmortalList<Event> events, MySchedule mySchedule) {
    final now = DateTime.now();
    final scheduledEvents = <int, Event>{};
    // TODO(SF) STYLE improve?
    events.forEach((event) {
      if (event.start
          .map((startTime) => startTime.isAfter(now))
          .orElse(false)) {
        mySchedule.getNotificationId(event.id).ifPresent((notificationId) {
          scheduledEvents[notificationId] = event;
        });
      }
    });
    // TODO(SF) NOTIFICATIONS handle updated events (e.g. time change)
    // schedule.updatedEvents.forEach((event) {
    //   mySchedule.getNotificationId(event.id).ifPresent((notificationId) {
    //     cancelNotification(notificationId);
    //     if (event.start
    //         .map((startTime) => startTime.isAfter(now))
    //         .orElse(false)) {
    //       scheduledEvents[notificationId] = event;
    //     }
    //   });
    // });
    return ImmortalMap(scheduledEvents);
  }

  void _verifyScheduledNotifications(
      ImmortalList<Event> events, MySchedule mySchedule) {
    initialized = true;
    if (events.isEmpty || mySchedule.isEmpty) {
      return;
    }
    dimeGet<Notifications>().verifyScheduledEventNotifications(
      _calculateRequiredNotifications(events, mySchedule),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = useProvider(dimeGet<ScheduleProvider>());
    final myScheduleProvider = useProvider(dimeGet<MyScheduleProvider>().state);
    if (!initialized) {
      schedule.whenData(
        (events) => myScheduleProvider.whenData(
          (mySchedule) => _verifyScheduledNotifications(events, mySchedule),
        ),
      );
    }
    return widget.child;
  }
}
