import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:immortal/immortal.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/event.dart';
import '../../models/festival_config.dart';
import '../../models/ids.dart';
import '../../models/my_schedule.dart';
import '../../models/theme.dart';
import '../../screens/band_detail_view/band_detail_view.dart';
import '../../utils/constants.dart';
import '../../utils/date.dart';
import '../../utils/i18n.dart';
import '../../utils/logging.dart';
import 'notifications.i18n.dart';

const notificationTimePeriodInMinutes = 15;

class Notifications {
  const Notifications();

  FlutterLocalNotificationsPlugin get _plugin =>
      dimeGet<FlutterLocalNotificationsPlugin>();
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Logger get _log => const Logger(module: 'NOTIFICATIONS');

  AndroidNotificationDetails get _androidPlatformChannelSpecifics =>
      AndroidNotificationDetails(
        Constants.notificationChannelId,
        'Gig Reminder'.i18n,
        channelDescription: 'Notifications to remind of liked gigs'.i18n,
        importance: Importance.max,
        priority: Priority.high,
        color: _theme.notificationColor,
      );

  Future _onSelectNotification(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      _log.debug(
        'Notification selected with payload: $payload '
        '- trying to open band detail view',
      );
      try {
        // ignore: avoid_dynamic_calls TODO(SF) fix this
        final bandName = jsonDecode(payload)['band'];
        BandDetailView.openFor(bandName ?? payload);
      } catch (error) {
        _log.error('Error parsing notification payload $payload', error);
        BandDetailView.openFor(payload);
      }
    }
  }

  Future<void> initializeNotificationPlugin() async {
    _log.debug('Initialize notification plugin');
    unawaited(
      _plugin
          .getNotificationAppLaunchDetails()
          .then((details) {
            if (details != null && details.didNotificationLaunchApp) {
              _log.debug('App was launched with notification');
            }
          })
          .catchError((error) {
            _log.error('Retrieving notification launch details failed', error);
          }),
    );

    // Request permissions
    final bool? result = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission()
        .then((success) {
          _log.debug('Received permission for notifications: $success');
        })
        .catchError((error) {
          _log.error('Retrieving notification launch details failed', error);
        });

    // TODO(SF): move initialization somewhere else if tz is used more often
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    _log.debug('Setting local timezone to $currentTimeZone');
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    if (!(result ?? false)) {
      // Did not receive permission to send notifications, skip initialization
      return;
    }

    await _plugin
        .initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings(Constants.notificationIcon),
            iOS: DarwinInitializationSettings(),
          ),
          onDidReceiveBackgroundNotificationResponse: _onSelectNotification,
          onDidReceiveNotificationResponse: _onSelectNotification,
        )
        .catchError((error) {
          _log.error('Initializing notification plugin failed', error);
          return false; // TODO(SF): ??
        });
  }

  Future<NotificationId> scheduleNotificationForEvent(
    Event event,
    NotificationId notificationId,
  ) async {
    if (event.isInFutureOf(currentDate())) {
      _log.debug(
        'Schedule notification for event ${event.id} with id '
        '$notificationId',
      );
      await _plugin
          .zonedSchedule(
            notificationId,
            _config.festivalName,
            '{band} plays at {time} on the {stage}!'.i18n.fill({
              'band': event.bandName,
              'time': 'HH:mm'.i18n.dateFormat(event.start.value),
              'stage': event.stage,
            }),
            // TODO(SF): FEATURE configuration option?
            tz.TZDateTime.from(
              event.start.value.subtract(
                const Duration(minutes: notificationTimePeriodInMinutes),
              ),
              tz.local,
            ),
            NotificationDetails(
              android: _androidPlatformChannelSpecifics,
              iOS: const DarwinNotificationDetails(),
            ),
            payload: event.notificationPayload,
            androidScheduleMode:
                AndroidScheduleMode.alarmClock, // TODO(SF): requires permission
          )
          .catchError((error) {
            // Will be retried on next app start if still necessary
            _log.error('Scheduling notification failed', error);
          });
    }
    return notificationId;
  }

  Future<void> cancelNotification(NotificationId notificationId) {
    _log.debug('Cancel notification with id $notificationId');
    return _plugin.cancel(notificationId).catchError((error) {
      _log.error('Cancelling notification failed', error);
    });
  }

  ImmortalMap<NotificationId, Event> _calculateRequiredNotifications(
    MySchedule mySchedule,
    ImmortalList<Event> events,
  ) {
    final now = currentDate();
    final scheduledEvents = <NotificationId, Event>{};
    for (final event in events) {
      if (event.isInFutureOf(now)) {
        mySchedule.getNotificationId(event.id).ifPresent((id) {
          scheduledEvents[id] = event;
        });
      }
    }
    return ImmortalMap(scheduledEvents);
  }

  Future<void> verifyScheduledEventNotifications(
    MySchedule mySchedule,
    ImmortalList<Event> events,
  ) async {
    final requiredNotifications = _calculateRequiredNotifications(
      mySchedule,
      events,
    );
    _log.debug('Verify required notifications $requiredNotifications');
    final pendingNotifications = await _plugin
        .pendingNotificationRequests()
        .catchError((error) {
          _log.error('Retrieving pending notifications failed', error);
          return <PendingNotificationRequest>[];
        });
    final pendingNotificationsMap = ImmortalMap.fromEntries(
      pendingNotifications.map((notification) {
        Map<String, dynamic> payload;
        try {
          payload = jsonDecode(notification.payload ?? '{}');
        } catch (error) {
          _log.error(
            'Error decoding notification payload ${notification.payload}',
            error,
          );
          payload = {};
        }
        return MapEntry(notification.id, payload);
      }),
    );

    // Cancel notifications that are not needed anymore
    pendingNotificationsMap.keys
        .difference(requiredNotifications.keys)
        .forEach(cancelNotification);
    // Schedule missing notifications
    await Future.wait(
      requiredNotifications
          .mapValues(
            (notificationId, event) => pendingNotificationsMap
                .get(notificationId)
                .map((payload) {
                  // Reschedule changed events
                  if (payload['hash'] != event.hashCode) {
                    return cancelNotification(notificationId).then(
                      (value) =>
                          scheduleNotificationForEvent(event, notificationId),
                    );
                  }
                  return Future.value(notificationId);
                })
                .orElseGet(
                  () => scheduleNotificationForEvent(event, notificationId),
                ),
          )
          .values,
    );
  }
}
