import 'dart:async';

import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:optional/optional.dart';

import '../models/combined_key.dart';
import '../models/event.dart';
import '../models/festival_config.dart';
import '../models/my_schedule.dart';
import '../services/app_storage.dart';
import '../services/notifications/notifications.dart';
import '../utils/constants.dart';
import '../utils/logging.dart';

class MyScheduleProvider
    extends Family<StateNotifierProvider<MyScheduleController>, String> {
  MyScheduleProvider() : super(_createProvider);

  static FestivalConfig get _config => dimeGet<FestivalConfig>();

  static StateNotifierProvider<MyScheduleController> _createProvider(
          String festivalId) =>
      festivalId == _config.festivalId
          ? StateNotifierProvider((ref) => MyScheduleController.create(
                festivalId: festivalId,
              ))
          // TODO(SF) STATE possible to use autodispose here?
          : StateNotifierProvider((ref) => MyScheduleController.create(
                festivalId: festivalId,
                // Only handle legacy file for oldest history festival
                handleLegacyFile: _config.history.lastOptional
                    .map((legacyFestival) => festivalId == legacyFestival.key)
                    .orElse(false),
              ));
}

class MyScheduleController extends StateNotifier<AsyncValue<MySchedule>> {
  MyScheduleController._({
    required this.festivalId,
    this.handleLegacyFile = false,
  }) : super(const AsyncValue<MySchedule>.loading());

  factory MyScheduleController.create({
    required String festivalId,
    bool handleLegacyFile = false,
  }) =>
      MyScheduleController._(
        festivalId: festivalId,
        handleLegacyFile: handleLegacyFile,
      ).._loadMySchedule();

  final String festivalId;
  final bool handleLegacyFile;
  Timer? _debounce;

  AppStorage get _appStorage => dimeGet<AppStorage>();
  Notifications get _notifications => dimeGet<Notifications>();
  Logger get _log => const Logger(module: 'MY_SCHEDULE');
  String get _appStorageFileName =>
      Constants.myScheduleAppStorageFileName(festivalId);

  Future<Optional<MySchedule>> _readFromAppStorage(String fileName) async {
    _log.debug('Reading from app storage');
    return _appStorage.loadJson(fileName).then((result) => result.map((json) {
          try {
            final data = Optional.of(MySchedule.fromJson(json));
            _log.debug('Reading from app storage was successful');
            return data;
          } catch (error) {
            _log.error('Error reading from app storage', error);
            return const Optional<MySchedule>.empty();
          }
        }).orElseGet(() {
          _log.debug('Reading from app storage failed');
          return const Optional<MySchedule>.empty();
        }));
  }

  Future<MySchedule> _readFromLegacyFile() {
    _log.debug('Reading from app storage failed, reading legacy file');
    return _readFromAppStorage(Constants.myScheduleAppStorageLegacyFileName)
        .then(
      (result) => result.map((mySchedule) {
        _log.debug('Copying legacy file to new file');
        _appStorage
            .storeJson(_appStorageFileName, mySchedule.toJson())
            .then((_) {
          _log.debug('Removing legacy file');
          _appStorage.removeFile(Constants.myScheduleAppStorageLegacyFileName);
        });
        return mySchedule;
      }).orElseGet(() {
        _log.debug('Reading from legacy file failed, using empty');
        return MySchedule.empty();
      }),
    );
  }

  Future<void> _loadMySchedule() async {
    final mySchedule = await _readFromAppStorage(_appStorageFileName).then(
      (result) => result.orElseGetAsync(handleLegacyFile
          ? _readFromLegacyFile
          : () async => MySchedule.empty()),
    );
    state = AsyncValue.data(mySchedule);
  }

  void _saveMySchedule() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      state.whenData((mySchedule) {
        _log.debug('Writing my schedule to app storage');
        _appStorage.storeJson(_appStorageFileName, mySchedule.toJson());
      });
    });
  }

  void toggleEvent(Event event) {
    _log.debug('Toggle schedule state of event ${event.id}');
    state.whenData((mySchedule) {
      final newSchedule = mySchedule.toggleEvent(event.id,
          onRemove: _notifications.cancelNotification,
          onAdd: (notificationId) => _notifications
              .scheduleNotificationForEvent(event, notificationId));
      _log.debug('Updating my schedule');
      state = AsyncValue.data(newSchedule);
      _saveMySchedule();
    });
  }
}

class EventKey extends CombinedKey<String, String> {
  const EventKey({
    required String festivalId,
    required String eventId,
  }) : super(key1: festivalId, key2: eventId);

  String get festivalId => key1;
  String get eventId => key2;
}

class LikedEventProvider extends Family<Computed<Optional<int>>, EventKey> {
  LikedEventProvider()
      : super((key) => Computed((read) =>
            read(dimeGet<MyScheduleProvider>()(key.festivalId).state).when(
              data: (mySchedule) => mySchedule.getNotificationId(key.eventId),
              loading: () => const Optional<int>.empty(),
              error: (_, __) => const Optional<int>.empty(),
            )));
}
