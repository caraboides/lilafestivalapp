import 'package:flutter/material.dart';

import '../../models/event.dart';
import 'event_details.dart';
import 'event_playing_indicator/event_playing_indicator.dart';
import 'event_toggle/event_toggle.dart';

class EventDetailRow extends StatelessWidget {
  const EventDetailRow({
    required this.event,
    required this.currentTime,
    super.key,
    this.dense = false,
  });

  final Event event;
  final bool dense;
  final DateTime currentTime;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: dense ? MainAxisSize.min : MainAxisSize.max,
    mainAxisAlignment:
        dense ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            EventToggle(event, dense: dense),
            const SizedBox(width: 8),
            Expanded(
              child: EventDetails(
                event,
                showBandName: !dense,
                showWeekDay: true,
              ),
            ),
          ],
        ),
      ),
      EventPlayingIndicator(isPlaying: event.isPlaying(currentTime)),
    ],
  );
}
