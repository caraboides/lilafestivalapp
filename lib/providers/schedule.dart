import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/event.dart';
import '../utils/combined_storage_stream_provider.dart';
import '../utils/constants.dart';
import '../utils/date.dart';

class ScheduleProvider
    extends CombinedStorageStreamProvider<ImmortalList<Event>> {
  ScheduleProvider(BuildContext context, String festivalId)
      : super(
          context: context,
          remoteUrl: '/schedule?festival=$festivalId',
          appStorageKey: Constants.scheduleAppStorageFileName,
          assetPath: Constants.scheduleAssetFileName,
          fromJson: (jsonMap) => ImmortalMap<String, dynamic>(jsonMap)
              .mapEntries<Event>((id, json) => Event.fromJson(id, json)),
        );
}

class SortedScheduleProvider extends Computed<AsyncValue<ImmortalList<Event>>> {
  SortedScheduleProvider()
      : super((read) => read(dimeGet<ScheduleProvider>())
            .whenData((events) => events.sort()));
}

class DailyScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Event>>, DateTime> {
  DailyScheduleProvider()
      : super((read, date) => read(dimeGet<SortedScheduleProvider>()).whenData(
            (events) => events.where((event) => event.start
                .map((startTime) => isSameFestivalDay(startTime, date))
                .orElse(false))));
}

class BandScheduleProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Event>>, String> {
  BandScheduleProvider()
      : super((read, band) => read(dimeGet<ScheduleProvider>()).whenData(
            (events) => events.where((event) => event.bandName == band)));
}
