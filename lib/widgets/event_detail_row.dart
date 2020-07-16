import 'package:flutter/material.dart';

import '../models/event.dart';
import 'event_details.dart';
import 'event_playing_indicator/event_playing_indicator.dart';
import 'event_toggle/event_toggle.dart';

class EventDetailRow extends StatelessWidget {
  const EventDetailRow({
    Key key,
    this.event,
    this.currentTime,
    this.dense = false,
  }) : super(key: key);

  final Event event;
  final bool dense;
  final DateTime currentTime;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: dense ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment:
            dense ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: [
          Row(children: <Widget>[
            dense
                ? SizedBox(height: 42, child: EventToggle(event))
                : EventToggle(event),
            const SizedBox(width: 8),
            EventDetails(
              event: event,
              showBandName: !dense,
              showWeekDay: true,
            ),
          ]),
          EventPlayingIndicator(isPlaying: event.isPlaying(currentTime)),
        ],
      );
}
