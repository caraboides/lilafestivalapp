import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/festival_config.dart';
import 'bands.dart';
import 'combined_schedule.dart';
import 'my_schedule.dart';
import 'schedule.dart';

class ContextModule extends BaseDimeModule {
  ContextModule(this.context);

  final BuildContext context;

  void _addScheduleProviders([DateTime date]) {
    // TODO(SF) necessary? constant?
    final tag = date?.toIso8601String() ?? 'allBands';
    addSingle<ScheduleFilterProvider>(
      date != null
          ? ScheduleFilterProvider.forDay(date)
          : ScheduleFilterProvider.allBands(),
      tag: tag,
    );
    addSingle<CombinedScheduleProvider>(
      CombinedScheduleProvider(tag),
      tag: tag,
    );
  }

  @override
  void updateInjections() {
    // TODO(SF) or use tag for festivalid?
    // TODO(SF) async?
    final festivalId = dimeGet<FestivalConfig>().festivalId;
    addSingle<BandsProvider>(BandsProvider(context, festivalId));
    addSingle<ScheduleProvider>(ScheduleProvider(context, festivalId));
    addSingle<MyScheduleProvider>(MyScheduleProvider());
    _addScheduleProviders();
    dimeGet<FestivalConfig>().days.forEach(_addScheduleProviders);
  }
}