import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/band_with_events.dart';
import '../models/event.dart';
import '../models/my_schedule.dart';
import '../utils/combined_async_value.dart';
import 'bands_with_events.dart';
import 'my_schedule.dart';
import 'schedule.dart';

// TODO(SF) STYLE naming - or create family with bool key?
class FilteredDailyScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Event>>, DateTime> {
  FilteredDailyScheduleProvider()
      : super((read, date) {
          final dailySchedule = read(dimeGet<DailyScheduleProvider>()(date));
          final myScheduleProvider = read(dimeGet<MyScheduleProvider>().state);
          return combineAsyncValues<ImmortalList<Event>, ImmortalList<Event>,
              MySchedule>(
            dailySchedule,
            myScheduleProvider,
            (events, mySchedule) => events.where(
                (event) => mySchedule.getNotificationId(event.id).isPresent),
          );
        });
}

class FilteredBandScheduleProvider
    extends Computed<AsyncValue<ImmortalList<BandWithEvents>>> {
  FilteredBandScheduleProvider()
      : super((read) {
          final bandsWithEvents = read(dimeGet<BandsWithEventsProvider>());
          final myScheduleProvider = read(dimeGet<MyScheduleProvider>().state);
          return combineAsyncValues<ImmortalList<BandWithEvents>,
                  ImmortalList<BandWithEvents>, MySchedule>(
              bandsWithEvents,
              myScheduleProvider,
              (bands, mySchedule) => bands.where((bandWithEvents) =>
                  bandWithEvents.events.any((event) =>
                      mySchedule.getNotificationId(event.id).isPresent)));
        });
}
