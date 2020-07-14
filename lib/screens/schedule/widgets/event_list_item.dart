import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../widgets/event_toggle/event_toggle.dart';
import '../../band_detail_view/band_detail_view.dart';
import 'event_details.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key key,
    this.event,
    this.isPlaying,
  }) : super(key: key);

  final Event event;
  final bool isPlaying;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  void _onTap(BuildContext context) =>
      BandDetailView.openFor(context, event.bandName);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isPlaying ? theme.accentColor : theme.canvasColor,
      child: InkWell(
        onTap: () => _onTap(context),
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: _theme.eventListItemHeight,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EventToggle(event),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    child: EventDetails(
                      event: event,
                      isBandView: false,
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
