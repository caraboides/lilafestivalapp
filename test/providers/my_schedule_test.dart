import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/models/event.dart';
import 'package:lilafestivalapp/models/my_schedule.dart';
import 'package:lilafestivalapp/providers/my_schedule.dart';
import 'package:lilafestivalapp/services/app_storage.dart';
import 'package:lilafestivalapp/services/notifications/notifications.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:optional/optional.dart';

import '../test_utils.dart';
import '../utils/combined_storage_stream_test.mocks.dart';
import 'my_schedule_test.mocks.dart';

@GenerateMocks([Notifications])
final MockAppStorage appStorageMock = MockAppStorage();
final MockNotifications notificationsMock = MockNotifications();

class TestModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<AppStorage>(appStorageMock);
    addSingle<Notifications>(notificationsMock);
  }
}

class MyScheduleMatcher extends Matcher {
  const MyScheduleMatcher(this.expectedSchedule);

  final Map<String, int> expectedSchedule;

  @override
  Description describe(Description description) =>
      description.add('matches MySchedule');

  @override
  bool matches(dynamic item, Map matchState) {
    if (!(item is MySchedule?) || item == null) {
      return false;
    }
    return ImmortalMap(item.toJson()).equals(ImmortalMap(expectedSchedule));
  }
}

const appStorageFileName = 'my_schedule/festival_id.json';
const legacyFileName = 'my_schedule.txt';
const event = Event(
  bandName: 'band',
  id: 'event1',
  stage: 'stage',
  start: Optional.empty(),
  end: Optional.empty(),
);
const testSchedule = {'event1': 1, 'event2': 2, 'event3': 3};

void main() {
  group('MyScheduleController', () {
    late MyScheduleController controller;

    setUpAll(() {
      dimeInstall(TestModule());
      // Supress debug prints
      debugPrint = (message, {wrapWidth}) {};
    });

    setUp(() {
      reset(appStorageMock);
    });

    tearDown(() {
      controller.dispose();
    });

    test('loads schedule from app storage', () async {
      when(
        appStorageMock.loadJson(any),
      ).thenAnswer(mockResponse(Optional.of(testSchedule)));

      controller = MyScheduleController.create(festivalId: 'festival_id');
      final state = await controller.stream.first;

      verify(appStorageMock.loadJson(appStorageFileName));
      expect(state.value, const MyScheduleMatcher(testSchedule));
    });

    test('loads schedule from legacy file if necessary', () async {
      when(
        appStorageMock.loadJson(appStorageFileName),
      ).thenAnswer(mockResponse(const Optional.empty()));
      when(
        appStorageMock.loadJson(legacyFileName),
      ).thenAnswer(mockResponse(Optional.of(testSchedule)));

      controller = MyScheduleController.create(
        festivalId: 'festival_id',
        handleLegacyFile: true,
      );
      final state = await controller.stream.first;

      verify(appStorageMock.loadJson(appStorageFileName));
      verify(appStorageMock.loadJson(legacyFileName));
      verify(appStorageMock.storeJson(appStorageFileName, testSchedule));
      verify(appStorageMock.removeFile(legacyFileName));
      expect(state.value, const MyScheduleMatcher(testSchedule));
    });

    test('ignores legacy file if not necessary', () async {
      when(
        appStorageMock.loadJson(appStorageFileName),
      ).thenAnswer(mockResponse(Optional.of(testSchedule)));
      when(
        appStorageMock.loadJson(legacyFileName),
      ).thenAnswer(mockResponse(const Optional.empty()));

      controller = MyScheduleController.create(
        festivalId: 'festival_id',
        handleLegacyFile: true,
      );
      final state = await controller.stream.first;

      verify(appStorageMock.loadJson(appStorageFileName));
      verifyNever(appStorageMock.loadJson(legacyFileName));
      verifyNever(appStorageMock.storeJson(appStorageFileName, testSchedule));
      verifyNever(appStorageMock.removeFile(legacyFileName));
      expect(state.value, const MyScheduleMatcher(testSchedule));
    });

    test('handles error when reading from app storage', () async {
      when(
        appStorageMock.loadJson(any),
      ).thenAnswer(mockResponse(Optional.of('foobar')));

      controller = MyScheduleController.create(festivalId: 'festival_id');
      final state = await controller.stream.first;

      verify(appStorageMock.loadJson(appStorageFileName));
      expect(state.value, const MyScheduleMatcher({}));
    });

    test('handles error when reading from legacy file', () async {
      when(
        appStorageMock.loadJson(any),
      ).thenAnswer(mockResponse(Optional.of('foobar')));

      controller = MyScheduleController.create(
        festivalId: 'festival_id',
        handleLegacyFile: true,
      );
      final state = await controller.stream.first;

      verify(appStorageMock.loadJson(appStorageFileName));
      verify(appStorageMock.loadJson(legacyFileName));
      verifyNever(appStorageMock.storeJson(appStorageFileName, testSchedule));
      verifyNever(appStorageMock.removeFile(legacyFileName));
      expect(state.value, const MyScheduleMatcher({}));
    });

    test('stores updates in app storage', () async {
      const updatedSchedule = {'event2': 2, 'event3': 3};
      when(
        appStorageMock.loadJson(any),
      ).thenAnswer(mockResponse(Optional.of(testSchedule)));

      controller = MyScheduleController.create(festivalId: 'festival_id');
      var initialized = false;
      final removeListener = controller.addListener((state) {
        state.whenData((value) {
          if (!initialized) {
            initialized = true;
            controller.toggleEvent(event);
          }
        });
      });

      final states = await controller.stream
          .take(2)
          .map((state) => state.value)
          .toList();
      await Future.delayed(const Duration(milliseconds: 500), () {});

      verify(notificationsMock.cancelNotification(1));
      verifyNever(notificationsMock.scheduleNotificationForEvent(any, any));
      verify(appStorageMock.storeJson(appStorageFileName, updatedSchedule));
      expect(states, [
        const MyScheduleMatcher(testSchedule),
        const MyScheduleMatcher(updatedSchedule),
      ]);

      removeListener();
    });
  });
}
