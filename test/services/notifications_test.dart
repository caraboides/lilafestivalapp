import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/models/event.dart';
import 'package:lilafestivalapp/models/festival_config.dart';
import 'package:lilafestivalapp/models/lat_lng.dart';
import 'package:lilafestivalapp/models/my_schedule.dart';
import 'package:lilafestivalapp/models/theme.dart';
import 'package:lilafestivalapp/services/notifications/notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:optional/optional.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../test_utils.dart';
import 'notifications_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin, FlutterTimezone])
final MockFlutterLocalNotificationsPlugin notificationsPlugin =
    MockFlutterLocalNotificationsPlugin();

final testFestivalConfig = FestivalConfig(
  festivalId: 'id',
  festivalName: 'name',
  festivalFullName: 'full_name',
  festivalUrl: Uri.parse('https://www.example.com'),
  startDate: DateTime.now(),
  endDate: DateTime.now(),
  daySwitchOffset: const Duration(hours: 3),
  fontReferences: ImmortalList.empty(),
  aboutMessages: ImmortalList.empty(),
  stageAlignment: (_) => CrossAxisAlignment.start,
  routes: ImmortalList.empty(),
  weatherGeoLocation: const LatLng(lat: 1, lng: 1),
  weatherCityId: 'weatherCityId',
  history: ImmortalList.empty(),
);

final testThemeData = ThemeData.dark();
const testColor = Colors.black;
final testFestivalTheme = FestivalTheme(
  theme: testThemeData,
  aboutTheme: testThemeData,
  menuTheme: testThemeData,
  historyTheme: testThemeData,
  primaryButton: ({required label, required onPressed}) => Container(),
  notificationColor: Colors.red,
  bannerBackgroundColor: testColor,
  bannerTextStyle: const TextStyle(),
  shimmerColor: testColor,
);

class TestModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<FlutterLocalNotificationsPlugin>(notificationsPlugin);
    addSingle<FestivalTheme>(testFestivalTheme);
    addSingle<FestivalConfig>(testFestivalConfig);
  }
}

class NotificationDetailsMatcher extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('matches NotificationDetails');

  @override
  bool matches(dynamic item, Map matchState) {
    if (!(item is NotificationDetails)) {
      return false;
    }
    final android = item.android;
    return android != null &&
        android.channelId == 'event_notification' &&
        android.channelName == 'Gig Reminder' &&
        android.channelDescription == 'Notifications to remind of liked gigs' &&
        android.importance == Importance.max &&
        android.priority == Priority.high &&
        android.color == Colors.red;
  }
}

const notifications = Notifications();
final testSchedule = MySchedule.fromJson({
  'event0': 0,
  'event1': 1,
  'event2': 2,
  'event4': 4,
  'event5': 5,
});
final startDate = DateTime(DateTime.now().year + 1, 8, 1, 20, 0);
// Scheduled + pending
final event1 = Event(
  bandName: 'band1',
  venueName: 'venue_name',
  id: 'event1',
  stage: 'stage',
  start: Optional.of(startDate),
  end: const Optional.empty(),
);
// Scheduled, not pending
final event2 = Event(
  bandName: 'band2',
  venueName: 'venue_name',
  id: 'event2',
  stage: 'stage',
  start: Optional.of(startDate.add(const Duration(hours: 1))),
  end: const Optional.empty(),
);
// Not scheduled, pending
final event3 = Event(
  bandName: 'band3',
  venueName: 'venue-name',
  id: 'event3',
  stage: 'stage',
  start: Optional.of(startDate.add(const Duration(hours: 2))),
  end: const Optional.empty(),
);
// Rescheduled + pending
final event4 = Event(
  bandName: 'band4',
  venueName: 'venue-name',
  id: 'event4',
  stage: 'stage',
  start: Optional.of(startDate.add(const Duration(hours: 3))),
  end: const Optional.empty(),
);
// Past + pending
final event5 = Event(
  bandName: 'band5',
  venueName: 'venue_name',
  id: 'event5',
  stage: 'stage',
  start: Optional.of(DateTime.now().subtract(const Duration(days: 1))),
  end: const Optional.empty(),
);
final testEvents = ImmortalList([event1, event2, event3, event4, event5]);
final testPendingNotifications = <PendingNotificationRequest>[
  PendingNotificationRequest(
    1,
    null,
    null,
    '{"band":"band1","id":"event1","hash":${event1.hashCode}}',
  ),
  PendingNotificationRequest(
    3,
    null,
    null,
    '{"band":"band3","id":"event3","hash":${event3.hashCode}}',
  ),
  const PendingNotificationRequest(
    4,
    null,
    null,
    '{"band":"band4","id":"event4","hash":-1}',
  ),
  const PendingNotificationRequest(
    5,
    null,
    null,
    '{"band":"band5","id":"event5","hash":-1}',
  ),
  const PendingNotificationRequest(6, null, null, null),
  const PendingNotificationRequest(7, null, null, 'invalid'),
];

void main() {
  group('Notifications', () {
    setUpAll(() {
      dimeInstall(TestModule());
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
      // Supress debug prints
      debugPrint = (message, {wrapWidth}) {};
    });

    setUp(() {
      reset(notificationsPlugin);
    });

    group('verifyScheduledEventNotifications', () {
      test('schedules missing notifications', () async {
        when(
          notificationsPlugin.pendingNotificationRequests(),
        ).thenAnswer(mockResponse(testPendingNotifications));
        await notifications.verifyScheduledEventNotifications(
          testSchedule,
          testEvents,
        );
        // Schedule missing
        verify(
          notificationsPlugin.zonedSchedule(
            2,
            'name',
            'band2 plays at 21:00 on the stage!',
            tz.TZDateTime.from(
              startDate.add(const Duration(minutes: 45)),
              tz.local,
            ),
            argThat(NotificationDetailsMatcher()),
            payload:
                '{"band":"band2","id":"event2",'
                '"hash":${event2.hashCode}}',
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          ),
        );
        // Reschedule changed
        verify(
          notificationsPlugin.zonedSchedule(
            4,
            'name',
            'band4 plays at 23:00 on the stage!',
            tz.TZDateTime.from(
              startDate.add(const Duration(minutes: 165)),
              tz.local,
            ),
            argThat(NotificationDetailsMatcher()),
            payload:
                '{"band":"band4","id":"event4",'
                '"hash":${event4.hashCode}}',
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          ),
        );
        // Do not schedule existing + obsolete
        verifyNever(
          notificationsPlugin.zonedSchedule(
            0,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
        verifyNever(
          notificationsPlugin.zonedSchedule(
            1,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
        verifyNever(
          notificationsPlugin.zonedSchedule(
            3,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
        verifyNever(
          notificationsPlugin.zonedSchedule(
            5,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
      });

      test('cancels unnecessary and rescheduled notifications', () async {
        when(
          notificationsPlugin.pendingNotificationRequests(),
        ).thenAnswer(mockResponse(testPendingNotifications));
        await notifications.verifyScheduledEventNotifications(
          testSchedule,
          testEvents,
        );
        verify(notificationsPlugin.cancel(3, tag: null));
        verify(notificationsPlugin.cancel(4, tag: null));
        verify(notificationsPlugin.cancel(5, tag: null));
        verify(notificationsPlugin.cancel(6, tag: null));
        verify(notificationsPlugin.cancel(7, tag: null));
        verifyNever(notificationsPlugin.cancel(1, tag: null));
        verifyNever(notificationsPlugin.cancel(2, tag: null));
      });

      test('handles error retrieving pending notifications', () async {
        when(
          notificationsPlugin.pendingNotificationRequests(),
        ).thenAnswer(mockError());
        await notifications.verifyScheduledEventNotifications(
          testSchedule,
          testEvents,
        );
        verify(
          notificationsPlugin.zonedSchedule(
            1,
            'name',
            'band1 plays at 20:00 on the stage!',
            tz.TZDateTime.from(
              startDate.subtract(const Duration(minutes: 15)),
              tz.local,
            ),
            argThat(NotificationDetailsMatcher()),
            payload:
                '{"band":"band1","id":"event1",'
                '"hash":${event1.hashCode}}',
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          ),
        );
        verify(
          notificationsPlugin.zonedSchedule(
            2,
            'name',
            'band2 plays at 21:00 on the stage!',
            tz.TZDateTime.from(
              startDate.add(const Duration(minutes: 45)),
              tz.local,
            ),
            argThat(NotificationDetailsMatcher()),
            payload:
                '{"band":"band2","id":"event2",'
                '"hash":${event2.hashCode}}',
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          ),
        );
        verify(
          notificationsPlugin.zonedSchedule(
            4,
            'name',
            'band4 plays at 23:00 on the stage!',
            tz.TZDateTime.from(
              startDate.add(const Duration(minutes: 165)),
              tz.local,
            ),
            argThat(NotificationDetailsMatcher()),
            payload:
                '{"band":"band4","id":"event4",'
                '"hash":${event4.hashCode}}',
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          ),
        );
        verifyNever(
          notificationsPlugin.zonedSchedule(
            3,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
        verifyNever(
          notificationsPlugin.zonedSchedule(
            5,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
        verifyNever(notificationsPlugin.cancel(any));
      });

      test('does nothing if schedule is empty', () async {
        when(
          notificationsPlugin.pendingNotificationRequests(),
        ).thenAnswer(mockResponse([]));
        await notifications.verifyScheduledEventNotifications(
          MySchedule.empty(),
          testEvents,
        );
        verifyNever(notificationsPlugin.cancel(any));
        verifyNever(
          notificationsPlugin.zonedSchedule(
            any,
            any,
            any,
            any,
            any,
            androidScheduleMode: anyNamed('androidScheduleMode'),
          ),
        );
      });
    });
  });
}
