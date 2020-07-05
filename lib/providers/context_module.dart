import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/festival_config.dart';
import 'schedule.dart';

class ContextModule extends BaseDimeModule {
  ContextModule(this.context);

  final BuildContext context;

  @override
  void updateInjections() {
    // TODO(SF) or use tag for festivalid?
    // TODO(SF) async?
    addSingle<ScheduleProvider>(
        ScheduleProvider(context, dimeGet<FestivalConfig>().festivalId));
    addSingle<ScheduleFilterProvider>(
      ScheduleFilterProvider.allBands(),
      tag: 'allBands', // TODO(SF) necessary? constant?
    );
    dimeGet<FestivalConfig>().days.forEach((day) {
      addSingle<ScheduleFilterProvider>(
        ScheduleFilterProvider.forDay(day),
        tag: day.toIso8601String(),
      );
    });
  }
}
