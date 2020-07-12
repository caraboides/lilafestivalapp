import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'event.dart';

// TODO(SF) STATE better make obsolete by using provider family
class EnhancedEvent {
  EnhancedEvent({
    this.event,
    this.toggleEvent,
    this.notificationId,
  });

  final Event event;
  final Optional<int> notificationId;
  final VoidCallback toggleEvent;

  bool get isScheduled => notificationId.isPresent;
}
