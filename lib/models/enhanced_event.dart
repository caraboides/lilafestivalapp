import 'package:flutter/material.dart';

import 'event.dart';

// TODO(SF) STATE better make obsolete by using provider family
class EnhancedEvent {
  EnhancedEvent({
    this.event,
    this.isScheduled,
    this.toggleEvent,
  });

  final Event event;
  final bool isScheduled;
  final VoidCallback toggleEvent;
}
