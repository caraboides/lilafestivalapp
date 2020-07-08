import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/scheduled_event.dart';
import '../../../providers/combined_schedule.dart';
import 'event_list_view.dart';
import 'no_liked_events.dart';

class FilteredEventList extends HookWidget {
  const FilteredEventList({
    Key key,
    this.scheduleFilterTag,
    this.date,
    this.openBandDetails,
    this.favoritesOnly,
  }) : super(key: key);

  final String scheduleFilterTag;
  final DateTime date;
  final ValueChanged<ScheduledEvent> openBandDetails;
  final bool favoritesOnly;

  @override
  Widget build(BuildContext context) =>
      useProvider(dimeGet<CombinedScheduleProvider>(tag: scheduleFilterTag))
          .when(
        data: (events) {
          // TODO(SF) use computed as well?
          final filteredEvents =
              !favoritesOnly ? events : events.filter((event) => event.isLiked);
          if (favoritesOnly && filteredEvents.isEmpty) {
            return NoLikedEvents();
          }
          return EventListView(
            events: filteredEvents,
            date: date,
            openBandDetails: openBandDetails,
          );
        },
        // TODO(SF)
        loading: () => Center(child: Text('Loading!')),
        error: (e, trace) => Center(
          child: Text('Error! $e ${trace.toString()}'),
        ),
      );
}
