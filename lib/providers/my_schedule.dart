import 'dart:async';

import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

import '../models/combined_key.dart';
import '../models/event.dart';
import '../models/festival_config.dart';
import '../models/ids.dart';
import '../models/my_schedule.dart';
import '../services/app_storage.dart';
import '../services/notifications/notifications.dart';
import '../utils/constants.dart';
import '../utils/logging.dart';

class EventKey extends CombinedKey<FestivalId, EventId> {
  const EventKey({
    required FestivalId festivalId,
    required EventId eventId,
  }) : super(key1: festivalId, key2: eventId);

  FestivalId get festivalId => key1;
  EventId get eventId => key2;
}

typedef MyScheduleProvider = AutoDisposeStateNotifierProviderFamily<
    MyScheduleController, AsyncValue<MySchedule>, FestivalId>;
typedef LikedEventProvider = ProviderFamily<Optional<NotificationId>, EventKey>;

class MyScheduleController extends StateNotifier<AsyncValue<MySchedule>> {
  MyScheduleController._({
    required this.festivalId,
    this.handleLegacyFile = false,
  }) : super(const AsyncValue<MySchedule>.loading());

  factory MyScheduleController.create({
    required FestivalId festivalId,
    bool handleLegacyFile = false,
  }) =>
      MyScheduleController._(
        festivalId: festivalId,
        handleLegacyFile: handleLegacyFile,
      ).._loadMySchedule();

  final FestivalId festivalId;
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

// ignore: avoid_classes_with_only_static_members
class MyScheduleProviderCreator {
  static FestivalConfig get _config => dimeGet<FestivalConfig>();

  static MyScheduleProvider create() =>
      StateNotifierProvider.autoDispose.family((ref, festivalId) {
        if (festivalId == _config.festivalId) {
          ref.maintainState = true;
          return MyScheduleController.create(
            festivalId: festivalId,
          );
        }
        return MyScheduleController.create(
          festivalId: festivalId,
          // Only handle legacy file for oldest history festival
          handleLegacyFile: _config.history.lastOptional
              .map((legacyFestival) => festivalId == legacyFestival.key)
              .orElse(false),
        );
      });

  static LikedEventProvider createLikedEventProvider() => Provider.family(
        (ref, eventKey) =>
            ref.read(dimeGet<MyScheduleProvider>()(eventKey.festivalId)).when(
                  data: (mySchedule) =>
                      mySchedule.getNotificationId(eventKey.eventId),
                  loading: () => const Optional<NotificationId>.empty(),
                  error: (_, __) => const Optional<NotificationId>.empty(),
                ),
      );
}
