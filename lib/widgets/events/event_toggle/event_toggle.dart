import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/event.dart';
import '../../../providers/festival_scope.dart';
import '../../../providers/my_schedule.dart';
import '../../toggle_like_button.dart';
import 'event_toggle.i18n.dart';

class EventToggle extends HookConsumerWidget {
  const EventToggle(this.event, {this.dense = false});

  final Event event;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalId = DimeFlutter.get<FestivalScope>(context).festivalId;
    final isLiked = ref
        .watch(
          dimeGet<LikedEventProvider>()(
            EventKey(festivalId: festivalId, eventId: event.id),
          ),
        )
        .isPresent;

    final button = ToggleLikeButton(
      toggleState: isLiked,
      tooltip:
          (isLiked ? 'Remove gig from schedule' : 'Add gig to schedule').i18n,
      onPressed: () => ref
          .read(dimeGet<MyScheduleProvider>()(festivalId).notifier)
          .toggleEvent(event),
      dense: dense,
    );
    return dense
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: button,
          )
        : button;
  }
}
