import 'package:flutter/material.dart';

import 'event_playing_indicator.i18n.dart';

class EventPlayingIndicator extends StatelessWidget {
  const EventPlayingIndicator({this.isPlaying = false});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) => Visibility(
    visible: isPlaying,
    child: SizedBox(
      width: 24,
      child: Tooltip(
        message: 'Gig is currently taking place'.i18n,
        child: const Center(child: Icon(Icons.priority_high)),
      ),
    ),
  );
}
