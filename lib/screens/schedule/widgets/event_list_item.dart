import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../models/festival_config.dart';
import '../../../models/scheduled_event.dart';
import '../../../models/theme.dart';
import '../../../widgets/event_date/event_date.dart';
import '../../../widgets/event_toggle/event_toggle.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key key,
    this.event,
    this.bandView,
    this.openEventDetails,
    this.isPlaying,
  }) : super(key: key);

  final ScheduledEvent event;
  final bool bandView;
  final VoidCallback openEventDetails;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final theme = dimeGet<FestivalTheme>();
    return Material(
      color: isPlaying ? theme.theme.accentColor : theme.theme.canvasColor,
      child: InkWell(
        onTap: openEventDetails,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: theme.eventListItemHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EventToggle(
                  isActive: event.isLiked,
                  onToggle: event.toggleEvent,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _EventDescription(
                      event: event.event,
                      bandView: bandView,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventDescription extends StatelessWidget {
  const _EventDescription({
    Key key,
    this.event,
    this.bandView,
  }) : super(key: key);

  final Event event;
  final bool bandView;

  @override
  Widget build(BuildContext context) {
    final config = dimeGet<FestivalConfig>();
    final theme = dimeGet<FestivalTheme>();
    return Column(
      crossAxisAlignment: bandView
          ? CrossAxisAlignment.start
          : config.stageAlignment(event.stage),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          event.bandName.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.eventBandTextStyle,
        ),
        const SizedBox(height: 4),
        EventDate(
          start: event.start,
          end: event.end,
          showWeekDay: bandView,
        ),
        const SizedBox(height: 2),
        Text(
          event.stage,
          style: theme.eventStageTextStyle,
        ),
      ],
    );
  }
}
