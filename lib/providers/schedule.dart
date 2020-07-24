import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/band_key.dart';
import '../models/combined_key.dart';
import '../models/event.dart';
import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../utils/cache_stream.dart';
import '../utils/combined_storage_stream.dart';
import '../utils/constants.dart';
import '../utils/date.dart';

class ScheduleProvider extends Family<
    ProviderBase<StreamProviderDependency<ImmortalList<Event>>,
        AsyncValue<ImmortalList<Event>>>,
    String> {
  ScheduleProvider(BuildContext context)
      : super((festivalId) => _createStreamProvider(
              festivalId: festivalId,
              context: context,
            ));

  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  static GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  static String _remoteUrl(String festivalId) =>
      '/schedule?festival=$festivalId';

  static ImmortalList<Event> _fromJson(Map<String, dynamic> jsonMap) =>
      ImmortalMap<String, dynamic>(jsonMap)
          .mapEntries<Event>((id, json) => Event.fromJson(id, json));

  static ProviderBase<StreamProviderDependency<ImmortalList<Event>>,
      AsyncValue<ImmortalList<Event>>> _createStreamProvider({
    @required String festivalId,
    @required BuildContext context,
  }) =>
      festivalId == _config.festivalId
          ? StreamProvider((ref) => createCombinedStorageStream(
                context: context,
                ref: ref,
                remoteUrl: _remoteUrl(festivalId),
                appStorageKey: Constants.scheduleAppStorageFileName,
                assetPath: Constants.scheduleAssetFileName,
                fromJson: _fromJson,
              ))
          : StreamProvider.autoDispose((ref) => createCacheStream(
                remoteUrl:
                    _globalConfig.festivalHubBaseUrl + _remoteUrl(festivalId),
                fromJson: _fromJson,
              ));
}

class SortedScheduleProvider
    extends Family<Computed<AsyncValue<ImmortalList<Event>>>, String> {
  SortedScheduleProvider()
      : super((festivalId) => Computed((read) =>
            read(dimeGet<ScheduleProvider>()(festivalId))
                .whenData((events) => events.sort())));
}

class DailyScheduleKey extends CombinedKey<String, DateTime> {
  const DailyScheduleKey({
    @required String festivalId,
    @required DateTime date,
  }) : super(key1: festivalId, key2: date);

  String get festivalId => key1;
  DateTime get date => key2;
}

class DailyScheduleProvider extends Family<
    Computed<AsyncValue<ImmortalList<Event>>>, DailyScheduleKey> {
  DailyScheduleProvider()
      : super((key) => Computed((read) =>
            read(dimeGet<SortedScheduleProvider>()(key.festivalId)).whenData(
              (events) => events.where((event) => event.start
                  .map((startTime) => isSameFestivalDay(startTime, key.date))
                  .orElse(false)),
            )));
}

class BandScheduleProvider
    extends Family<Computed<AsyncValue<ImmortalList<Event>>>, BandKey> {
  BandScheduleProvider()
      : super((key) => Computed(
              (read) => read(dimeGet<ScheduleProvider>()(key.festivalId))
                  .whenData((events) =>
                      events.where((event) => event.bandName == key.bandName)),
            ));
}

class FestivalDaysProvider
    extends Family<Computed<AsyncValue<ImmortalList<DateTime>>>, String> {
  FestivalDaysProvider()
      : super((festivalId) => Computed((read) =>
            read(dimeGet<ScheduleProvider>()(festivalId)).whenData(
              (events) => events
                  .map((event) => event.start.map(toFestivalDay).orElse(null))
                  .toSet()
                  .remove(null)
                  .toList()
                  .sort(),
            )));
}
