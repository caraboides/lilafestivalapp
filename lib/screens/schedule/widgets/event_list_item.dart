import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../models/festival_config.dart';
import '../../../models/scheduled_event.dart';
import '../../../models/theme.dart';
import '../../../widgets/event_date/event_date.dart';
import '../../../widgets/event_stage.dart';
import '../../../widgets/event_toggle/event_toggle.dart';
import 'event_band_name.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key key,
    this.scheduledEvent,
    this.isBandView,
    this.openBandDetails,
    this.isPlaying,
  }) : super(key: key);

  final ScheduledEvent scheduledEvent;
  final bool isBandView;
  final VoidCallback openBandDetails;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isPlaying ? theme.accentColor : theme.canvasColor,
      child: InkWell(
        onTap: openBandDetails,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: dimeGet<FestivalTheme>().eventListItemHeight,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EventToggle(
                  isActive: scheduledEvent.isLiked,
                  onToggle: scheduledEvent.toggleEvent,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: _EventDetails(
                      event: scheduledEvent.event,
                      isBandView: isBandView,
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

class _EventDetails extends StatelessWidget {
  const _EventDetails({
    Key key,
    this.event,
    this.isBandView,
  }) : super(key: key);

  final Event event;
  final bool isBandView;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: isBandView
            ? CrossAxisAlignment.start
            : dimeGet<FestivalConfig>().stageAlignment(event.stage),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EventBandName(event.bandName),
          const SizedBox(height: 3.5),
          EventDate(
            start: event.start,
            end: event.end,
            showWeekDay: isBandView,
          ),
          const SizedBox(height: 2.5),
          EventStage(event.stage),
        ],
      );
}
