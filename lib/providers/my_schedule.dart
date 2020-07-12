import 'dart:async';

import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

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

  // TODO(SF) STATE pass to my schedule?
  void toggleEvent(Event event) {
    _log.debug('Toggle schedule state of event ${event.id}');
    state.whenData((mySchedule) {
      // TODO(SF) STATE/STYLE move to event toggle?
      mySchedule
          .toggleEvent(event.id,
              onRemove: _notifications.cancelNotification,
              generateValue: () =>
                  _notifications.scheduleNotificationForEvent(event))
          .then((newSchedule) {
        _log.debug('Updating my schedule');
        state = AsyncValue.data(newSchedule);
        _saveMySchedule();
      });
    });
  }
}
