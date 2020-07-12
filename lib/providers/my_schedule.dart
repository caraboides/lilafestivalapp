import 'dart:async';

import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/event.dart';
import '../models/my_schedule.dart';
import '../services/app_storage.dart';
import '../services/notifications/notifications.dart';

// TODO(SF) ERROR HANDLING
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

  void _loadMySchedule() => _appStorage
          .loadJson(_myScheduleFileName)
          .then((result) => result
              // TODO(SF) ERROR HANDLING
              .map((json) => MySchedule.fromJson(json))
              .orElse(MySchedule.empty()))
          .then((value) {
        state = AsyncValue.data(value);
      });

  void _saveMySchedule() {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      state.whenData((mySchedule) =>
          _appStorage.storeJson(_myScheduleFileName, mySchedule.toJson()));
    });
  }

  // TODO(SF) STATE pass to my schedule?
  void toggleEvent(Event event) {
    state.whenData((mySchedule) {
      // TODO(SF) STATE/STYLE move to event toggle?
      mySchedule
          .toggleEvent(event.id,
              onRemove: _notifications.cancelNotification,
              generateValue: () =>
                  _notifications.scheduleNotificationForEvent(event))
          .then((newSchedule) {
        state = AsyncValue.data(newSchedule);
        _saveMySchedule();
      });
    });
  }
}
