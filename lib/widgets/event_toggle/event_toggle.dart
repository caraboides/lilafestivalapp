import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/event.dart';
import '../../providers/my_schedule.dart';
import 'event_toggle.i18n.dart';

class EventToggle extends HookWidget {
  const EventToggle({
    @required this.event,
    @required this.festivalId,
  });

  final String festivalId;
  final Event event;

  @override
  Widget build(BuildContext context) {
    final isLiked = useProvider(dimeGet<LikedEventProvider>()(EventKey(
      festivalId: festivalId,
      eventId: event.id,
    ))).isPresent;
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(isLiked ? Icons.star : Icons.star_border),
      tooltip:
          (isLiked ? 'Remove gig from schedule' : 'Add gig to schedule').i18n,
      onPressed: () => dimeGet<MyScheduleProvider>()(festivalId)
          .read(context)
          .toggleEvent(event),
    );
  }
}
