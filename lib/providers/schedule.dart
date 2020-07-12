import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/event.dart';
import '../utils/combined_storage_stream_provider.dart';
import '../utils/date.dart';

// TODO(SF) ERROR HANDLING
class ScheduleProvider
    extends CombinedStorageStreamProvider<ImmortalList<Event>> {
  ScheduleProvider(BuildContext context, String festivalId)
      : super(
          context: context,
          remoteUrl: '/schedule?festival=$festivalId',
          appStorageKey: 'schedule.json',
          assetPath: 'assets/schedule.json',
          // TODO(SF) ERROR HANDLING
          fromJson: (jsonMap) => ImmortalMap<String, dynamic>(jsonMap)
              .mapEntries<Event>((id, json) => Event.fromJson(id, json)),
        );
}

class ScheduleFilterProvider extends Computed<AsyncValue<ImmortalList<Event>>> {
  ScheduleFilterProvider._(this.filter)
      : super((read) => read(dimeGet<ScheduleProvider>()).whenData(filter));

  factory ScheduleFilterProvider.allBands() => ScheduleFilterProvider._(
        (events) => events.sort((a, b) => a.bandName.compareTo(b.bandName)),
      );

  factory ScheduleFilterProvider.forDay(DateTime day) =>
      ScheduleFilterProvider._(
        (events) => events
            .where((item) => item.start
                .map((startTime) => isSameFestivalDay(startTime, day))
                .orElse(false))
            .sort(),
      );

  final ImmortalList<Event> Function(ImmortalList<Event>) filter;
}
