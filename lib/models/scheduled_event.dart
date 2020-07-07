import 'package:flutter/cupertino.dart';

import 'event.dart';

class ScheduledEvent {
  ScheduledEvent({
    this.event,
    this.isLiked,
    this.toggleEvent,
  });

  final Event event;
  final bool isLiked;
  final VoidCallback toggleEvent;
}
