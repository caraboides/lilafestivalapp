import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immortal/immortal.dart';
import 'package:pedantic/pedantic.dart';

import '../../models/enhanced_event.dart';
import '../../models/event.dart';
import '../../models/festival_config.dart';
import '../../models/theme.dart';
import '../../utils/i18n.dart';
import '../../utils/logging.dart';
import 'notifications.i18n.dart';

class Notifications {
  int _nextNotificationId = 0;

  FlutterLocalNotificationsPlugin get _plugin =>
      dimeGet<FlutterLocalNotificationsPlugin>();
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Logger get _log => const Logger('NOTIFICATIONS');

  // TODO(SF) BUILD release proguard: -keep class com.dexterous.** { *; }

  AndroidNotificationDetails get _androidPlatformChannelSpecifics =>
      AndroidNotificationDetails(
        'event_notification', // TODO(SF) CONFIG constant
        'Gig Reminder'.i18n,
        'Notifications to remind of scheduled gigs'.i18n,
        importance: Importance.Max,
        priority: Priority.High,
        color: _theme.notificationColor,
      );

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      // TODO(SF) FEATURE handle this somehow?
      _log.debug('Notification selected with payload: $payload');
    }
  }

  void initializeNotificationPlugin() {
    _log.debug('Initialize notification plugin');
    _plugin.getNotificationAppLaunchDetails().then((details) {
      if (details != null && details.didNotificationLaunchApp) {
        _log.debug('App was launched with notification');
      }
    }).catchError((error) {
      _log.error('Retrieving notification launch details failed', error);
    });

    _plugin
        .initialize(
      const InitializationSettings(
        AndroidInitializationSettings('notification_icon'),
        IOSInitializationSettings(),
      ),
      onSelectNotification: _onSelectNotification,
    )
        .catchError((error) {
      _log.error('Initializing notification plugin failed', error);
    });
  }

  Future<int> scheduleNotificationForEvent(
    Event event, [
    int notificationId,
  ]) async {
    final id = notificationId ?? _nextNotificationId++;
    if (event.start
        .map((startTime) => startTime.isAfter(DateTime.now()))
        .orElse(false)) {
      _log.debug('Schedule notification for event ${event.id} with id $id');
      await _plugin
          .schedule(
        id,
        _config.festivalName,
        '{band} plays at {time} on the {stage}!'.i18n.fill({
          'band': event.bandName,
          'time': 'HH:mm'.i18n.dateFormat(event.start.value),
          'stage': event.stage,
        }),
        // TODO(SF) FEATURE configuration option?
        event.start.value.subtract(const Duration(minutes: 10)),
        NotificationDetails(
          _androidPlatformChannelSpecifics,
          const IOSNotificationDetails(),
        ),
        payload: event.id,
      )
          .catchError((error) {
        // Will be retried on next app start if still necessary
        _log.error('Scheduling notification failed', error);
      });
    }
    return id;
  }

  Future<void> cancelNotification(int notificationId) {
    _log.debug('Cancel notification with id $notificationId');
    return _plugin.cancel(notificationId).catchError((error) {
      _log.error('Cancelling notification failed', error);
    });
  }

  // TODO(SF) TEST
  ImmortalMap<int, Event> _calculateRequiredNotifications(
    ImmortalList<EnhancedEvent> events,
  ) {
    final now = DateTime.now();
    final scheduledEvents = <int, Event>{};
    // TODO(SF) STYLE improve?
    events.forEach((enhancedEvent) {
      if (enhancedEvent.event.start
          .map((startTime) => startTime.isAfter(now))
          .orElse(false)) {
        enhancedEvent.notificationId.ifPresent((id) {
          scheduledEvents[id] = enhancedEvent.event;
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

  Future<void> verifyScheduledEventNotifications(
    ImmortalList<EnhancedEvent> events,
  ) async {
    _nextNotificationId = events.fold(
        _nextNotificationId,
        (previousMax, event) => event.notificationId
            .map((id) => max(id + 1, previousMax))
            .orElse(previousMax));
    final requiredNotifications = _calculateRequiredNotifications(events);
    _log.debug('Verify required notifications $requiredNotifications');
    final pendingNotifications =
        await _plugin.pendingNotificationRequests().catchError((error) {
      _log.error('Retrieving pending notifications failed', error);
      return [];
    });
    // TODO(SF) STYLE improve
    final scheduledNotifications = {};
    for (final notification in pendingNotifications) {
      _nextNotificationId = max(_nextNotificationId, notification.id + 1);
      if (requiredNotifications[notification.id] == null) {
        unawaited(cancelNotification(notification.id));
      } else {
        scheduledNotifications[notification.id] = true;
      }
    }
    requiredNotifications.forEach((notificationId, event) {
      if (scheduledNotifications[notificationId] == null) {
        unawaited(scheduleNotificationForEvent(event, notificationId));
      }
    });
  }
}
