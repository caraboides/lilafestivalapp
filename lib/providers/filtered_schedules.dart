import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:quiver/core.dart';

import '../models/band_with_events.dart';
import '../models/combined_key.dart';
import '../models/event.dart';
import '../models/ids.dart';
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
  final FestivalId festivalId;
  final bool likedOnly;

  DailyScheduleKey get dailyScheduleKey =>
      DailyScheduleKey(festivalId: festivalId, date: date);

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

typedef FilteredDailyScheduleProvider =
    ProviderFamily<AsyncValue<ImmortalList<EventId>>, DailyScheduleFilter>;

typedef FilteredBandScheduleProvider =
    ProviderFamily<AsyncValue<ImmortalList<BandName>>, BandScheduleKey>;

class BandScheduleKey extends CombinedKey<FestivalId, bool> {
  const BandScheduleKey({
    required FestivalId festivalId,
    required bool likedOnly,
  }) : super(key1: festivalId, key2: likedOnly);

  FestivalId get festivalId => key1;
  bool get likedOnly => key2;
}

class FilteredScheduleProviderCreator {
  static FilteredDailyScheduleProvider createFilteredDailyScheduleProvider() =>
      ProviderFamily<AsyncValue<ImmortalList<EventId>>, DailyScheduleFilter>((
        ref,
        filter,
      ) {
        final dailySchedule = ref.watch(
          dimeGet<DailyScheduleProvider>()(filter.dailyScheduleKey),
        );
        final myScheduleProvider = ref.watch(
          dimeGet<MyScheduleProvider>()(filter.festivalId),
        );
        return combineAsyncValues<
          ImmortalList<EventId>,
          ImmortalList<Event>,
          MySchedule
        >(
          dailySchedule,
          myScheduleProvider,
          (events, mySchedule) =>
              (filter.likedOnly
                      ? events.where(
                          (event) => mySchedule.isEventLiked(event.id),
                        )
                      : events)
                  .map((event) => event.id),
        );
      });

  static FilteredBandScheduleProvider createFilteredBandScheduleProvider() =>
      Provider.family<AsyncValue<ImmortalList<BandName>>, BandScheduleKey>((
        ref,
        bandScheduleKey,
      ) {
        final bandsWithEvents = ref.watch(
          dimeGet<SortedBandsWithEventsProvider>()(bandScheduleKey.festivalId),
        );
        final myScheduleProvider = ref.watch(
          dimeGet<MyScheduleProvider>()(bandScheduleKey.festivalId),
        );
        return combineAsyncValues<
          ImmortalList<BandName>,
          ImmortalList<BandWithEvents>,
          MySchedule
        >(
          bandsWithEvents,
          myScheduleProvider,
          (bands, mySchedule) =>
              (bandScheduleKey.likedOnly
                      ? bands.where(
                          (bandWithEvents) => bandWithEvents.events.any(
                            (event) => mySchedule.isEventLiked(event.id),
                          ),
                        )
                      : bands)
                  .map((band) => band.bandName),
        );
      });
}
