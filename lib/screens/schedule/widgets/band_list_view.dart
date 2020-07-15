import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/band_with_events.dart';
import 'band_list_item.dart';

class BandListView extends StatelessWidget {
  const BandListView({Key key, this.bands}) : super(key: key);

  final ImmortalList<BandWithEvents> bands;

  ImmortalList<Widget> _buildListItems() {
    final now = DateTime.now();
    return bands.map<Widget>((bandWithEvents) => BandListItem(
          key: Key(bandWithEvents.bandName),
          bandWithEvents: bandWithEvents,
          isPlaying: bandWithEvents.isPlaying(now),
        ));
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: _buildListItems().toMutableList(),
        ).toList(),
      );
}