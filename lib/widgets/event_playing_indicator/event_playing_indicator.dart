import 'package:flutter/material.dart';

import 'event_playing_indicator.i18n.dart';

class EventPlayingIndicator extends StatelessWidget {
  const EventPlayingIndicator({this.isPlaying = false});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) => isPlaying
      ? Tooltip(
          message: 'Gig is currently taking place'.i18n,
          child: Icon(Icons.priority_high),
        )
      : const SizedBox(width: 24);
}
