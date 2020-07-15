import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:quiver/core.dart';

import '../models/band_with_events.dart';
import '../models/event.dart';
import '../models/my_schedule.dart';
import '../utils/combined_async_values.dart';
import 'bands_with_events.dart';
import 'my_schedule.dart';
import 'schedule.dart';

@immutable
class DailyScheduleFilter {
  const DailyScheduleFilter({
    this.date,
    this.likedOnly,
  });

  final DateTime date;
  final bool likedOnly;

  @override
  int get hashCode => hash2(date.hashCode, likedOnly.hashCode);

  @override
  bool operator ==(dynamic other) =>
      other is DailyScheduleFilter &&
      date == other.date &&
      likedOnly == other.likedOnly;
}

class FilteredDailyScheduleProvider extends ComputedFamily<
    AsyncValue<ImmortalList<Event>>, DailyScheduleFilter> {
  FilteredDailyScheduleProvider()
      : super((read, filter) {
          final dailySchedule =
              read(dimeGet<DailyScheduleProvider>()(filter.date));
          final myScheduleProvider = read(dimeGet<MyScheduleProvider>().state);
          return combineAsyncValues<ImmortalList<Event>, ImmortalList<Event>,
                  MySchedule>(
              dailySchedule,
              myScheduleProvider,
              (events, mySchedule) => filter.likedOnly
                  ? events.where((event) => mySchedule.isEventLiked(event.id))
                  : events);
        });
}

class FilteredBandScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<BandWithEvents>>, bool> {
  FilteredBandScheduleProvider()
      : super((read, likedOnly) {
          final bandsWithEvents = read(dimeGet<BandsWithEventsProvider>());
          final myScheduleProvider = read(dimeGet<MyScheduleProvider>().state);
          return combineAsyncValues<ImmortalList<BandWithEvents>,
                  ImmortalList<BandWithEvents>, MySchedule>(
              bandsWithEvents,
              myScheduleProvider,
              (bands, mySchedule) => likedOnly
                  ? bands.where((bandWithEvents) => bandWithEvents.events
                      .any((event) => mySchedule.isEventLiked(event.id)))
                  : bands);
        });
}
