import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../models/event.dart';
import 'event_detail_row.dart';

class DenseEventList extends StatelessWidget {
  const DenseEventList({
    @required this.events,
    @required this.currentTime,
    this.wrapAlignment = WrapAlignment.spaceBetween,
  });

  final ImmortalList<Event> events;
  final DateTime currentTime;
  final WrapAlignment wrapAlignment;

  Widget _buildEventRow(Event event) => FractionallySizedBox(
        widthFactor: 0.5,
        child: EventDetailRow(
          event: event,
          key: Key(event.id),
          currentTime: currentTime,
          dense: true,
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: events.map(_buildEventRow).toMutableList(),
        ),
      );
}
