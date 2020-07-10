import 'dart:async';

import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/event.dart';
import '../models/my_schedule.dart';
import '../services/app_storage.dart';

class MyScheduleProvider extends StateNotifierProvider<MyScheduleController> {
  MyScheduleProvider() : super((ref) => MyScheduleController.create());
}

// TODO(SF) collection of constants
const _myScheduleFileName = 'my_schedule.txt';

// TODO(SF) move somewhere else?
class MyScheduleController extends StateNotifier<AsyncValue<MySchedule>> {
  MyScheduleController._() : super(const AsyncValue<MySchedule>.loading());

  factory MyScheduleController.create() =>
      MyScheduleController._().._loadMySchedule();

  Timer _debounce;

  AppStorage get _appStorage => dimeGet<AppStorage>();

  void _loadMySchedule() => _appStorage
          .loadJson(_myScheduleFileName)
          .then((result) => result
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

  // TODO(SF) pass to my schedule?
  void toggleEvent(Event event) {
    state.whenData((mySchedule) {
      mySchedule
          .toggleEvent(
        event.id,
        onRemove: (_) {},
        // TODO(SF) NOTIFICATION
        // onRemove: cancelNotification,
        // generateValue: () async => event.start.isAfter(DateTime.now())
        //   ? await scheduleNotificationForEvent(event)
        //   : 0
        generateValue: () => Future.value(0),
      )
          .then((newSchedule) {
        state = AsyncValue.data(newSchedule);
        _saveMySchedule();
      });
    });
  }
}
