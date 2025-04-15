import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../../models/band_with_events.dart';
import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../screens/band_detail_view/band_detail_view.dart';
import '../../bands/band_cancelled/band_cancelled.dart';
import '../../events/dense_event_list.dart';
import '../../events/event_band_name.dart';
import '../../events/event_detail_row.dart';
import 'material_color_transition.dart';

class BandListItem extends StatelessWidget {
  const BandListItem({
    required this.bandWithEvents,
    required this.currentTime,
    super.key,
  });

  final BandWithEvents bandWithEvents;
  final DateTime currentTime;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  Widget _buildBandName() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(child: EventBandName(bandWithEvents.bandName)),
      BandCancelled(bandWithEvents),
    ],
  );

  Widget _buildSingleEventEntry(Event event) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: EventDetailRow(event: event, currentTime: currentTime),
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
      DenseEventList(events: bandWithEvents.events, currentTime: currentTime),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialColorTransition(
      color:
          bandWithEvents.isPlaying(currentTime)
              ? theme.colorScheme.secondary
              : theme.canvasColor,
      child: InkWell(
        onTap:
            () => BandDetailView.openFor(
              bandWithEvents.bandName,
              context: context,
            ),
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: const EdgeInsets.only(left: 10),
          child: Container(
            constraints: BoxConstraints(
              minHeight: _theme.bandListItemMinHeight,
            ),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child:
                bandWithEvents.events.length == 1
                    ? _buildSingleEventEntry(bandWithEvents.events.first)
                    : _buildMultiEventEntry(),
          ),
        ),
      ),
    );
  }
}
