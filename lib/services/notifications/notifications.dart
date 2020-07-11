import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immortal/immortal.dart';
import 'package:pedantic/pedantic.dart';

import '../../models/event.dart';
import '../../models/festival_config.dart';
import '../../models/theme.dart';
import '../../utils/i18n.dart';
import 'notifications.i18n.dart';

class Notifications {
  int _nextNotificationId = 0;

  FlutterLocalNotificationsPlugin get _plugin =>
      dimeGet<FlutterLocalNotificationsPlugin>();
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  // TODO(SF) BUILD proguard: -keep class com.dexterous.** { *; }

  AndroidNotificationDetails get _androidPlatformChannelSpecifics =>
      AndroidNotificationDetails(
        'event_notification', // TODO(SF) CONFIG constant
        'Gig Reminder'.i18n,
        'Notification to remind of scheduled gigs'.i18n,
        importance: Importance.Max,
        priority: Priority.High,
        color: _theme.notificationColor,
      );

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      // TODO(SF) STATE add more debugprints everywhere
      // TODO(SF) FEATURE handle this somehow?
      debugPrint('notification payload: $payload');
    }
  }

  void initializeNotificationPlugin() {
    _plugin.getNotificationAppLaunchDetails().then((details) {
      if (details != null && details.didNotificationLaunchApp) {
        debugPrint('was launched with notification');
      }
    });

    _plugin.initialize(
      const InitializationSettings(
        // TODO(SF) BUILD flavorize
        AndroidInitializationSettings('notification_icon'),
        IOSInitializationSettings(),
      ),
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<int> scheduleNotificationForEvent(
    Event event, [
    int notificationId,
  ]) async {
    final id = notificationId ?? _nextNotificationId++;
    await _plugin.schedule(
      id,
      _config.festivalName,
      '{band} plays at {time} on the {stage}!'.i18n.fill({
        'band': event.bandName,
        'time': 'HH:mm'.i18n.dateFormat(event.start),
        'stage': event.stage,
      }),
      // TODO(SF) FEATURE configuration option?
      event.start.subtract(const Duration(minutes: 10)),
      NotificationDetails(
        _androidPlatformChannelSpecifics,
        const IOSNotificationDetails(),
      ),
      payload: event.id,
    );
    return id;
  }

  Future<void> cancelNotification(int notificationId) =>
      _plugin.cancel(notificationId);

  Future<void> verifyScheduledEventNotifications(
    ImmortalMap<int, Event> requiredNotifications,
  ) async {
    final pendingNotifications = await _plugin.pendingNotificationRequests();
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
        scheduleNotificationForEvent(event, notificationId);
      }
    });
  }
}
