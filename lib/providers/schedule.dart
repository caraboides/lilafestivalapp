import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/event.dart';
import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../utils/band_key.dart';
import '../utils/cache_stream.dart';
import '../utils/combined_key.dart';
import '../utils/combined_storage_stream.dart';
import '../utils/constants.dart';
import '../utils/date.dart';

class ScheduleProvider
    extends StreamProviderFamily<ImmortalList<Event>, String> {
  ScheduleProvider(BuildContext context)
      : super((ref, festivalId) => _createStream(
              ref: ref,
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

  static Stream<ImmortalList<Event>> _createStream({
    @required ProviderReference ref,
    @required String festivalId,
    @required BuildContext context,
  }) =>
      festivalId == _config.festivalId
          ? createCombinedStorageStream(
              context: context,
              ref: ref,
              remoteUrl: _remoteUrl(festivalId),
              appStorageKey: Constants.scheduleAppStorageFileName,
              assetPath: Constants.scheduleAssetFileName,
              fromJson: _fromJson,
            )
          : createCacheStream(
              remoteUrl:
                  _globalConfig.festivalHubBaseUrl + _remoteUrl(festivalId),
              fromJson: _fromJson,
            );
}

class SortedScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Event>>, String> {
  SortedScheduleProvider()
      : super((read, festivalId) =>
            read(dimeGet<ScheduleProvider>()(festivalId))
                .whenData((events) => events.sort()));
}

class DailyScheduleKey extends CombinedKey<String, DateTime> {
  const DailyScheduleKey({
    @required String festivalId,
    @required DateTime date,
  }) : super(key1: festivalId, key2: date);

  String get festivalId => key1;
  DateTime get date => key2;
}

class DailyScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Event>>, DailyScheduleKey> {
  DailyScheduleProvider()
      : super((read, key) =>
            read(dimeGet<SortedScheduleProvider>()(key.festivalId)).whenData(
              (events) => events.where((event) => event.start
                  .map((startTime) => isSameFestivalDay(startTime, key.date))
                  .orElse(false)),
            ));
}

class BandScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Event>>, BandKey> {
  BandScheduleProvider()
      : super((read, key) => read(dimeGet<ScheduleProvider>()(key.festivalId))
            .whenData((events) =>
                events.where((event) => event.bandName == key.bandName)));
}
