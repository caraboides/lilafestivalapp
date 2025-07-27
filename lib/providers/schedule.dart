import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/band_key.dart';
import '../models/combined_key.dart';
import '../models/event.dart';
import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../models/ids.dart';
import '../utils/cache_stream.dart';
import '../utils/combined_storage_stream.dart';
import '../utils/constants.dart';
import '../utils/date.dart';

typedef ScheduleProvider =
    StreamProviderFamily<ImmortalList<Event>, FestivalId>;

typedef SortedScheduleProvider =
    ProviderFamily<AsyncValue<ImmortalList<Event>>, FestivalId>;

typedef FestivalDaysProvider =
    ProviderFamily<AsyncValue<ImmortalList<DateTime>>, FestivalId>;

class DailyScheduleKey extends CombinedKey<FestivalId, DateTime> {
  const DailyScheduleKey({
    required FestivalId festivalId,
    required DateTime date,
  }) : super(key1: festivalId, key2: date);

  FestivalId get festivalId => key1;
  DateTime get date => key2;
}

typedef DailyScheduleProvider =
    ProviderFamily<AsyncValue<ImmortalList<Event>>, DailyScheduleKey>;

typedef DailyScheduleMapProvider =
    ProviderFamily<AsyncValue<ImmortalMap<EventId, Event>>, DailyScheduleKey>;

typedef BandScheduleProvider =
    ProviderFamily<AsyncValue<ImmortalList<Event>>, BandKey>;

class ScheduleProviderCreator {
  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  static GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();
  static ScheduleProvider get _scheduleProvider => dimeGet<ScheduleProvider>();

  static String _remoteUrl(FestivalId festivalId) =>
      '/schedule?festival=$festivalId';

  static ImmortalList<Event> _fromJson(Map<String, dynamic> jsonMap) =>
      ImmortalMap<String, dynamic>(jsonMap).mapEntries<Event>(
        (id, json) => Event.fromJson(id, json as Map<String, dynamic>),
      );

  static ScheduleProvider create(BuildContext context) =>
      StreamProvider.family<ImmortalList<Event>, FestivalId>((ref, festivalId) {
        if (festivalId == _config.festivalId) {
          return createCombinedStorageStream(
            context: context,
            ref: ref,
            remoteUrl: _remoteUrl(festivalId),
            appStorageKey: Constants.scheduleAppStorageFileName,
            assetPath: Constants.scheduleAssetFileName,
            fromJson: _fromJson,
            periodicDuration: _globalConfig.scheduleReloadDuration,
          );
        }
        // TODO(SF): autodispose?
        return createCacheStream(
          remoteUrl: _globalConfig.festivalHubBaseUrl + _remoteUrl(festivalId),
          fromJson: _fromJson,
        );
      });

  static SortedScheduleProvider createSortedProvider() =>
      Provider.family<AsyncValue<ImmortalList<Event>>, FestivalId>(
        (ref, festivalId) => ref
            .watch(_scheduleProvider(festivalId))
            .whenData((events) => events.sort()),
      );

  static FestivalDaysProvider createFestivalDaysProvider() =>
      Provider.family<AsyncValue<ImmortalList<DateTime>>, FestivalId>(
        (ref, festivalId) =>
            ref.watch(_scheduleProvider(festivalId)).whenData((events) {
              if (festivalId == _config.festivalId) {
                return _config.festivalDays;
              }
              return events
                  .filterMapOptional((event) => event.start.map(toFestivalDay))
                  .toImmortalSet()
                  .toImmortalList()
                  .sort();
            }),
      );

  static DailyScheduleProvider createDailyScheduleProvider() =>
      Provider.family<AsyncValue<ImmortalList<Event>>, DailyScheduleKey>(
        (ref, dailyScheduleKey) => ref
            .watch(
              dimeGet<SortedScheduleProvider>()(dailyScheduleKey.festivalId),
            )
            .whenData(
              (events) => events.where(
                (event) => event.start
                    .map(
                      (startTime) =>
                          isSameFestivalDay(startTime, dailyScheduleKey.date),
                    )
                    .orElse(false),
              ),
            ),
      );

  static DailyScheduleMapProvider createDailyScheduleMapProvider() =>
      Provider.family<
        AsyncValue<ImmortalMap<EventId, Event>>,
        DailyScheduleKey
      >(
        (ref, dailyScheduleKey) => ref
            .watch(dimeGet<DailyScheduleProvider>()(dailyScheduleKey))
            .whenData(
              (eventList) => eventList.asMapWithKeys((event) => event.id),
            ),
      );

  static BandScheduleProvider createBandsScheduleProvider() =>
      Provider.family<AsyncValue<ImmortalList<Event>>, BandKey>(
        (ref, bandKey) => ref
            .watch(_scheduleProvider(bandKey.festivalId))
            .whenData(
              (events) =>
                  events.where((event) => event.bandName == bandKey.bandName),
            ),
      );
}
