import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:quiver/core.dart';

import '../models/band_with_events.dart';
import '../models/combined_key.dart';
import '../models/event.dart';
import '../models/my_schedule.dart';
import '../utils/combined_async_values.dart';
import 'bands_with_events.dart';
import 'my_schedule.dart';
import 'schedule.dart';

@immutable
class DailyScheduleFilter {
  const DailyScheduleFilter({
    @required this.date,
    @required this.festivalId,
    this.likedOnly = false,
  });

  final DateTime date;
  final String festivalId;
  final bool likedOnly;

  DailyScheduleKey get dailyScheduleKey => DailyScheduleKey(
        festivalId: festivalId,
        date: date,
      );

  @override
  int get hashCode =>
      hash3(date.hashCode, festivalId.hashCode, likedOnly.hashCode);

  @override
  bool operator ==(dynamic other) =>
      other is DailyScheduleFilter &&
      date == other.date &&
      festivalId == other.festivalId &&
      likedOnly == other.likedOnly;
}

class FilteredDailyScheduleProvider extends Family<
    Computed<AsyncValue<ImmortalList<Event>>>, DailyScheduleFilter> {
  FilteredDailyScheduleProvider()
      : super((key) => Computed((read) {
              final dailySchedule =
                  read(dimeGet<DailyScheduleProvider>()(key.dailyScheduleKey));
              final myScheduleProvider =
                  read(dimeGet<MyScheduleProvider>()(key.festivalId).state);
              return combineAsyncValues<ImmortalList<Event>,
                      ImmortalList<Event>, MySchedule>(
                  dailySchedule,
                  myScheduleProvider,
                  (events, mySchedule) => key.likedOnly
                      ? events
                          .where((event) => mySchedule.isEventLiked(event.id))
                      : events);
            }));
}

class BandScheduleKey extends CombinedKey<String, bool> {
  const BandScheduleKey({
    @required String festivalId,
    @required bool likedOnly,
  }) : super(key1: festivalId, key2: likedOnly);

  String get festivalId => key1;
  bool get likedOnly => key2;
}

class FilteredBandScheduleProvider extends Family<
    Computed<AsyncValue<ImmortalList<BandWithEvents>>>, BandScheduleKey> {
  FilteredBandScheduleProvider()
      : super((key) => Computed((read) {
              final bandsWithEvents =
                  read(dimeGet<BandsWithEventsProvider>()(key.festivalId));
              final myScheduleProvider =
                  read(dimeGet<MyScheduleProvider>()(key.festivalId).state);
              return combineAsyncValues<ImmortalList<BandWithEvents>,
                      ImmortalList<BandWithEvents>, MySchedule>(
                  bandsWithEvents,
                  myScheduleProvider,
                  (bands, mySchedule) => key.likedOnly
                      ? bands.where((bandWithEvents) => bandWithEvents.events
                          .any((event) => mySchedule.isEventLiked(event.id)))
                      : bands);
            }));
}
