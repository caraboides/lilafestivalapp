import 'package:flutter/material.dart';

import '../models/event.dart';
import 'event_details.dart';
import 'event_playing_indicator/event_playing_indicator.dart';
import 'event_toggle/event_toggle.dart';

class EventDetailRow extends StatelessWidget {
  const EventDetailRow({
    @required this.festivalId,
    @required this.event,
    @required this.currentTime,
    Key key,
    this.dense = false,
  }) : super(key: key);

  final String festivalId;
  final Event event;
  final bool dense;
  final DateTime currentTime;

  Widget _buildToggle() => EventToggle(festivalId: festivalId, event: event);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: dense ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment:
            dense ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: [
          Row(children: <Widget>[
            dense
                ? SizedBox(height: 42, child: _buildToggle())
                : _buildToggle(),
            const SizedBox(width: 8),
            EventDetails(event, showBandName: !dense, showWeekDay: true),
          ]),
          EventPlayingIndicator(isPlaying: event.isPlaying(currentTime)),
        ],
      );
}
