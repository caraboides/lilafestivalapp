import 'package:flutter/cupertino.dart';
import 'package:immortal/immortal.dart';

import '../models/event.dart';
import 'event_detail_row.dart';

class DenseEventList extends StatelessWidget {
  const DenseEventList({
    this.events,
    this.currentTime,
    this.wrapAlignment = WrapAlignment.spaceBetween,
  });

  final ImmortalList<Event> events;
  final DateTime currentTime;
  final WrapAlignment wrapAlignment;

  Widget _buildEventRow(Event event) => EventDetailRow(
        key: Key(event.id),
        event: event,
        currentTime: currentTime,
        dense: true,
      );

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: wrapAlignment,
          children: events.map(_buildEventRow).toMutableList(),
        ),
      );
}
