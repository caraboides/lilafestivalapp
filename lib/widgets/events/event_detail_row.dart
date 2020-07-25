import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../models/theme.dart';
import 'event_details.dart';
import 'event_playing_indicator/event_playing_indicator.dart';
import 'event_toggle/event_toggle.dart';

class EventDetailRow extends StatelessWidget {
  const EventDetailRow({
    @required this.event,
    @required this.currentTime,
    Key key,
    this.dense = false,
  }) : super(key: key);

  final Event event;
  final bool dense;
  final DateTime currentTime;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

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
                dense
                    ? SizedBox(
                        height: _theme.denseEventListItemHeight,
                        child: EventToggle(event),
                      )
                    : EventToggle(event),
                const SizedBox(width: 8),
                Expanded(
                    child: EventDetails(event,
                        showBandName: !dense, showWeekDay: true)),
              ],
            ),
          ),
          EventPlayingIndicator(isPlaying: event.isPlaying(currentTime)),
        ],
      );
}
