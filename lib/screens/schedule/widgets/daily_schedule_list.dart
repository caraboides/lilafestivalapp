import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/filtered_schedules.dart';
import '../../../utils/logging.dart';
import 'empty_schedule.dart';
import 'event_list_view.dart';

class DailyScheduleList extends HookWidget {
  const DailyScheduleList({
    Key key,
    this.date,
    this.likedOnly,
  }) : super(key: key);

  final DateTime date;
  final bool likedOnly;

  Logger get _log => const Logger('DailyScheduleList');

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(dimeGet<FilteredDailyScheduleProvider>()(
        DailyScheduleFilter(date: date, likedOnly: likedOnly)));
    return provider.when(
      data: (events) {
        // TODO(SF) ERROR HANDLING list should not be empty > should this be
        // handled & logged sooner?
        if (events.isEmpty) {
          return likedOnly
              ? EmptySchedule()
              // TODO(SF) THEME
              : const Center(
                  child: Text('Error! Event list should not be empty!'));
        }
        return EventListView(
          events: events,
          date: date,
        );
      },
      // TODO(SF) THEME
      loading: () => const Center(child: Text('Loading!')),
      error: (error, trace) {
        _log.error(
            'Error retrieving ${likedOnly ? "filtered" : "full"} schedule for '
            '${date.toIso8601String()}',
            error,
            trace);
        return Center(
          child: Text('Error! $error ${trace.toString()}'),
        );
      },
    );
  }
}
