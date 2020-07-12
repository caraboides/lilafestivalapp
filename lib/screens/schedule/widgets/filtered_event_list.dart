import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/combined_schedule.dart';
import '../../../utils/logging.dart';
import 'empty_schedule.dart';
import 'event_list_view.dart';

class FilteredEventList extends HookWidget {
  const FilteredEventList({
    Key key,
    this.date,
    this.scheduledOnly,
  }) : super(key: key);

  final DateTime date;
  final bool scheduledOnly;

  String get _scheduleFilterTag => date?.toIso8601String();
  Logger get _log => const Logger('FilteredEventList');

  @override
  Widget build(BuildContext context) =>
      useProvider(dimeGet<CombinedScheduleProvider>(tag: _scheduleFilterTag))
          .when(
        data: (events) {
          // TODO(SF) STATE use computed as well?
          // TODO(SF) ERROR HANDLING list should not be empty > should this be
          // handled & logged sooner?
          final filteredEvents = scheduledOnly
              ? events.filter((event) => event.isScheduled)
              : events;
          if (filteredEvents.isEmpty) {
            return scheduledOnly
                ? EmptySchedule()
                // TODO(SF) THEME
                : const Center(
                    child: Text('Error! Event list should not be empty!'));
          }
          return EventListView(
            events: filteredEvents,
            date: date,
          );
        },
        // TODO(SF) THEME
        loading: () => const Center(child: Text('Loading!')),
        error: (error, trace) {
          _log.error(
              'Error retrieving combined schedule for '
              '${_scheduleFilterTag ?? "allBands"}',
              error,
              trace);
          return Center(
            child: Text('Error! $error ${trace.toString()}'),
          );
        },
      );
}
