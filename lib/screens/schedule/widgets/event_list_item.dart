import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../models/festival_config.dart';
import '../../../models/theme.dart';
import '../../../utils/i18n.dart';
import 'event_list_item.i18n.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key key,
    this.isLiked,
    this.event,
    this.toggleEvent,
    this.bandView,
    this.openEventDetails,
    this.isPlaying,
  }) : super(key: key);

  final bool isLiked;
  final Event event;
  final VoidCallback toggleEvent;
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
                IconButton(
                  icon: Icon(isLiked ? Icons.star : Icons.star_border),
                  tooltip: (isLiked
                          ? 'Remove gig from schedule'
                          : 'Add gig to schedule')
                      .i18n,
                  onPressed: toggleEvent,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _EventDescription(
                      event: event,
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              (bandView ? 'E HH:mm' : 'HH:mm').i18n.dateFormat(event.start),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.eventDateTextStyle,
            ),
            Text(
              ' - ${'HH:mm'.i18n.dateFormat(event.end)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: bandView
                  ? theme.eventDateTextStyle
                  : theme.eventDateTextStyle
                      .copyWith(color: Colors.black.withOpacity(0.33)),
            ),
          ],
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
