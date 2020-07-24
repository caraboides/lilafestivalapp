import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../screens/band_detail_view/band_detail_view.dart';
import '../../events/event_details.dart';
import '../../events/event_toggle/event_toggle.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    @required this.event,
    this.isPlaying = false,
    Key key,
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
                      event,
                      showBandName: true,
                      alignByStage: true,
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
