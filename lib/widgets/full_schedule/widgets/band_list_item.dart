import 'package:flutter/material.dart';

import '../../../models/band_with_events.dart';
import '../../../models/event.dart';
import '../../../screens/band_detail_view/band_detail_view.dart';
import '../../band_cancelled/band_cancelled.dart';
import '../../dense_event_list.dart';
import '../../event_band_name.dart';
import '../../event_detail_row.dart';

class BandListItem extends StatelessWidget {
  const BandListItem({
    @required this.bandWithEvents,
    @required this.currentTime,
    Key key,
  }) : super(key: key);

  final BandWithEvents bandWithEvents;
  final DateTime currentTime;

  void _onTap(BuildContext context) =>
      BandDetailView.openFor(context, bandWithEvents.bandName);

  Widget _buildBandName() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: EventBandName(bandWithEvents.bandName),
          ),
          BandCancelled(bandWithEvents),
        ],
      );

  Widget _buildSingleEventEntry(Event event) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: EventDetailRow(
          event: event,
          currentTime: currentTime,
        ),
      );

  Widget _buildMultiEventEntry() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 10),
              child: _buildBandName(),
            ),
            DenseEventList(
              events: bandWithEvents.events,
              currentTime: currentTime,
            ),
          ]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: bandWithEvents.isPlaying(currentTime)
          ? theme.accentColor
          : theme.canvasColor,
      child: InkWell(
        onTap: () => _onTap(context),
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 38),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: bandWithEvents.events.length == 1
                ? _buildSingleEventEntry(bandWithEvents.events.first.value)
                : _buildMultiEventEntry(),
          ),
        ),
      ),
    );
  }
}
