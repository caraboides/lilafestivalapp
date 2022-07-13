import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../providers/festival_scope.dart';
import '../../../providers/my_schedule.dart';
import 'event_toggle.i18n.dart';

class EventToggle extends HookConsumerWidget {
  const EventToggle(this.event, {this.dense = false});

  final Event event;
  final bool dense;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  static const _iconSize = 24.0;

  Widget _buildIconButton({
    required double size,
    required BuildContext context,
    required Widget icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) =>
      Semantics(
        button: true,
        enabled: true,
        child: InkResponse(
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: size, minHeight: size),
              child: Container(
                height: _iconSize,
                width: _iconSize,
                alignment: Alignment.center,
                child: icon,
              ),
            ),
          ),
          splashColor: _theme.toggleSplashColor,
          radius: dense
              ? _theme.toggleDenseSplashRadius
              : Material.defaultSplashRadius,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalId = DimeFlutter.get<FestivalScope>(context).festivalId;
    final isLiked = ref
        .watch(dimeGet<LikedEventProvider>()(EventKey(
          festivalId: festivalId,
          eventId: event.id,
        )))
        .isPresent;
    final size = dense ? _theme.toggleDenseIconSize : _theme.toggleIconSize;

    final button = _buildIconButton(
        context: context,
        size: size,
        icon: AnimatedCrossFade(
          firstChild: const Icon(Icons.star),
          secondChild: const Icon(Icons.star_border),
          crossFadeState:
              isLiked ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 150),
        ),
        tooltip:
            (isLiked ? 'Remove gig from schedule' : 'Add gig to schedule').i18n,
        // TODO(SF) NEXT correct? or use ref.read?
        onPressed: () => (dimeGet<MyScheduleProvider>()(festivalId).notifier
                as MyScheduleController)
            .toggleEvent(event));
    return dense
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: button,
          )
        : button;
  }
}
