import 'dart:async';

import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:optional/optional.dart';

import '../models/event.dart';
import '../models/my_schedule.dart';
import '../services/app_storage.dart';
import '../services/notifications/notifications.dart';
import '../utils/logging.dart';

class MyScheduleProvider extends StateNotifierProvider<MyScheduleController> {
  MyScheduleProvider() : super((ref) => MyScheduleController.create());
}

// TODO(SF) STYLE collection of constants
const _myScheduleFileName = 'my_schedule.txt';

class MyScheduleController extends StateNotifier<AsyncValue<MySchedule>> {
  MyScheduleController._() : super(const AsyncValue<MySchedule>.loading());

  factory MyScheduleController.create() =>
      MyScheduleController._().._loadMySchedule();

  Timer _debounce;

  AppStorage get _appStorage => dimeGet<AppStorage>();
  Notifications get _notifications => dimeGet<Notifications>();
  Logger get _log => const Logger('MY_SCHEDULE');

  Future<void> _loadMySchedule() async {
    _log.debug('Reading from app storage');
    final result = await _appStorage.loadJson(_myScheduleFileName);
    final mySchedule = result.map((json) {
      try {
        final data = MySchedule.fromJson(json);
        _log.debug('Reading from app storage was successful');
        return data;
      } catch (error) {
        _log.error('Error reading from app storage, using empty', error);
        return MySchedule.empty();
      }
    }).orElseGet(() {
      _log.debug('Reading from app storage failed, using empty');
      return MySchedule.empty();
    });
    state = AsyncValue.data(mySchedule);
  }

  void _saveMySchedule() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      state.whenData((mySchedule) {
        _log.debug('Writing my schedule to app storage');
        _appStorage.storeJson(_myScheduleFileName, mySchedule.toJson());
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

class LikedEventProvider extends ComputedFamily<Optional<int>, String> {
  LikedEventProvider()
      : super((read, eventId) => read(dimeGet<MyScheduleProvider>().state).when(
            data: (mySchedule) => mySchedule.getNotificationId(eventId),
            loading: () => const Optional<int>.empty(),
            error: (_, __) => const Optional<int>.empty()));
}
