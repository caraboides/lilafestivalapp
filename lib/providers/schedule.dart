import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/event.dart';
import '../models/festival_config.dart';
import '../utils/date.dart';
import '../utils/stream_fallback_provider.dart';

class ScheduleProvider extends StreamFallbackProvider<ImmortalList<Event>> {
  ScheduleProvider(BuildContext context, String festivalId)
      : super(
          context: context,
          remoteUrl: Optional.of('/schedule?festival=$festivalId'),
          appStorageKey: Optional.of('schedule.json'),
          fallbackDataAssetKey: Optional.of('assets/initial_schedule.json'),
          fromJson: (jsonMap) => ImmortalMap<String, dynamic>(jsonMap)
              .mapEntries<Event>((id, json) => Event.fromJson(id, json)),
        );
}

// TODO(SF) does this work??
class ScheduleFilterProvider extends Computed<AsyncValue<ImmortalList<Event>>> {
  ScheduleFilterProvider._(this.filter)
      : super((read) => read(dimeGet<ScheduleProvider>()).whenData(filter));

  final ImmortalList<Event> Function(ImmortalList<Event>) filter;

  factory ScheduleFilterProvider.allBands() => ScheduleFilterProvider._(
        (events) => events.sort((a, b) => a.bandName.compareTo(b.bandName)),
      );

  factory ScheduleFilterProvider.forDay(DateTime day) =>
      ScheduleFilterProvider._(
        (events) => events
            .where((item) => isSameDay(item.start, day,
                offset: dimeGet<FestivalConfig>().daySwitchOffset))
            .sort((a, b) => a.start.compareTo(b.start)),
      );
}
