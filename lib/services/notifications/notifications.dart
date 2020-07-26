import 'package:dime/dime.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immortal/immortal.dart';

import '../../models/event.dart';
import '../../models/festival_config.dart';
import '../../models/my_schedule.dart';
import '../../models/theme.dart';
import '../../screens/band_detail_view/band_detail_view.dart';
import '../../utils/constants.dart';
import '../../utils/i18n.dart';
import '../../utils/logging.dart';
import 'notifications.i18n.dart';

class Notifications {
  const Notifications();

  FlutterLocalNotificationsPlugin get _plugin =>
      dimeGet<FlutterLocalNotificationsPlugin>();
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Logger get _log => const Logger(module: 'NOTIFICATIONS');

  // TODO(SF) BUILD release proguard: -keep class com.dexterous.** { *; }

  AndroidNotificationDetails get _androidPlatformChannelSpecifics =>
      AndroidNotificationDetails(
        Constants.notificationChannelId,
        'Gig Reminder'.i18n,
        'Notifications to remind of liked gigs'.i18n,
        importance: Importance.Max,
        priority: Priority.High,
        color: _theme.notificationColor,
      );

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      _log.debug('Notification selected with payload: $payload '
          '- opening band detail view');
      BandDetailView.openFor(payload);
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
        AndroidInitializationSettings(Constants.notificationIcon),
        IOSInitializationSettings(),
      ),
      onSelectNotification: _onSelectNotification,
    )
        .catchError((error) {
      _log.error('Initializing notification plugin failed', error);
    });
  }

  Future<int> scheduleNotificationForEvent(
    Event event,
    int notificationId,
  ) async {
    if (event.isInFutureOf(DateTime.now())) {
      _log.debug('Schedule notification for event ${event.id} with id '
          '$notificationId');
      await _plugin
          .schedule(
        notificationId,
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
        payload: event.bandName,
        androidAllowWhileIdle: true,
      )
          .catchError((error) {
        // Will be retried on next app start if still necessary
        _log.error('Scheduling notification failed', error);
      });
    }
    return notificationId;
  }

  Future<void> cancelNotification(int notificationId) {
    _log.debug('Cancel notification with id $notificationId');
    return _plugin.cancel(notificationId).catchError((error) {
      _log.error('Cancelling notification failed', error);
    });
  }

  // TODO(SF) TEST
  ImmortalMap<int, Event> _calculateRequiredNotifications(
    MySchedule mySchedule,
    ImmortalList<Event> events,
  ) {
    final now = DateTime.now();
    final scheduledEvents = <int, Event>{};
    events.forEach((event) {
      if (event.isInFutureOf(now)) {
        mySchedule.getNotificationId(event.id).ifPresent((id) {
          scheduledEvents[id] = event;
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
    MySchedule mySchedule,
    ImmortalList<Event> events,
  ) async {
    final requiredNotifications =
        _calculateRequiredNotifications(mySchedule, events);
    _log.debug('Verify required notifications $requiredNotifications');
    final pendingNotifications =
        await _plugin.pendingNotificationRequests().catchError((error) {
      _log.error('Retrieving pending notifications failed', error);
      return [];
    });
    final pendingNotificationIds = ImmortalSet(
        pendingNotifications.map((notification) => notification.id));
    // Cancel notifications that are not needed anymore
    pendingNotificationIds
        .difference(requiredNotifications.keys)
        .forEach(cancelNotification);
    // Schedule missing notifications
    requiredNotifications.forEach((notificationId, event) {
      if (!pendingNotificationIds.contains(notificationId)) {
        scheduleNotificationForEvent(event, notificationId);
      }
    });
  }
}
