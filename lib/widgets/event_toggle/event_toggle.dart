import 'package:flutter/material.dart';

import 'event_toggle.i18n.dart';

class EventToggle extends StatelessWidget {
  const EventToggle({
    this.isActive,
    this.onToggle,
  });

  final bool isActive;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(isActive ? Icons.star : Icons.star_border),
        tooltip: (isActive ? 'Remove gig from schedule' : 'Add gig to schedule')
            .i18n,
        onPressed: onToggle,
      );
}
