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
    required this.date,
    required this.festivalId,
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

typedef FilteredDailyScheduleProvider
    = ProviderFamily<AsyncValue<ImmortalList<String>>, DailyScheduleFilter>;

typedef FilteredBandScheduleProvider
    = ProviderFamily<AsyncValue<ImmortalList<String>>, BandScheduleKey>;

class BandScheduleKey extends CombinedKey<String, bool> {
  const BandScheduleKey({
    required String festivalId,
    required bool likedOnly,
  }) : super(key1: festivalId, key2: likedOnly);

  String get festivalId => key1;
  bool get likedOnly => key2;
}

// ignore: avoid_classes_with_only_static_members
class FilteredScheduleProviderCreator {
  static FilteredDailyScheduleProvider createFilteredDailyScheduleProvider() =>
      ProviderFamily<AsyncValue<ImmortalList<String>>, DailyScheduleFilter>(
          (ref, key) {
        final dailySchedule =
            ref.read(dimeGet<DailyScheduleProvider>()(key.dailyScheduleKey));
        final myScheduleProvider =
            ref.read(dimeGet<MyScheduleProvider>()(key.festivalId));
        return combineAsyncValues<ImmortalList<String>, ImmortalList<Event>,
                MySchedule>(
            dailySchedule,
            myScheduleProvider,
            (events, mySchedule) => (key.likedOnly
                    ? events.where((event) => mySchedule.isEventLiked(event.id))
                    : events)
                .map((event) => event.id));
      });

  static FilteredBandScheduleProvider createFilteredBandScheduleProvider() =>
      Provider.family<AsyncValue<ImmortalList<String>>, BandScheduleKey>(
          (ref, key) {
        final bandsWithEvents =
            ref.read(dimeGet<SortedBandsWithEventsProvider>()(key.festivalId));
        final myScheduleProvider =
            ref.read(dimeGet<MyScheduleProvider>()(key.festivalId));
        return combineAsyncValues<ImmortalList<String>,
                ImmortalList<BandWithEvents>, MySchedule>(
            bandsWithEvents,
            myScheduleProvider,
            (bands, mySchedule) => (key.likedOnly
                    ? bands.where((bandWithEvents) => bandWithEvents.events
                        .any((event) => mySchedule.isEventLiked(event.id)))
                    : bands)
                .map((band) => band.bandName));
      });
}
