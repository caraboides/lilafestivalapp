import 'package:flutter/material.dart';

import '../../../models/band_with_events.dart';
import '../../../widgets/event_toggle/event_toggle.dart';
import '../../band_detail_view/band_detail_view.dart';
import 'event_details.dart';

class BandListItem extends StatelessWidget {
  const BandListItem({
    Key key,
    this.bandWithEvents,
    this.isPlaying,
  }) : super(key: key);

  final BandWithEvents bandWithEvents;
  final bool isPlaying;

  void _onTap(BuildContext context) =>
      BandDetailView.openFor(context, bandWithEvents.bandName);

  // TODO(SF) THEME only display band name once for multiple events
  Widget _buildEvents() => Column(
        children: bandWithEvents.events
            .map((event) => Row(
                  key: Key(event.id),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    EventToggle(event),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 16),
                        child: EventDetails(
                          event: event,
                          isBandView: true,
                        ),
                      ),
                    )
                  ],
                ))
            .toMutableList(),
      );

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
            // TODO(SF) THEME maybe set min height?
            // height: _theme.eventListItemHeight,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _buildEvents(),
          ),
        ),
      ),
    );
  }
}
