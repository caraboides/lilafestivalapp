import 'dart:math';

import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/band_with_events.dart';
import '../../../models/theme.dart';
import 'alphabetical_list_view.dart';
import 'band_list_item.dart';

class BandListView extends StatelessWidget {
  const BandListView(this.bands, {Key key}) : super(key: key);

  final ImmortalList<BandWithEvents> bands;

  static final _isLetterRegex = RegExp(r'^[a-zA-Z]+$');

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  double _getListItemHeight(int numEvents) => numEvents == 1
      ? _theme.eventListItemHeight
      : min(
          _theme.bandListHeaderHeight +
              (numEvents / 2).ceil() * _theme.denseEventListItemHeight,
          _theme.bandListItemMinHeight);

  ImmortalList<double> _calculateListItemHeights() => bands.map(
      (bandWithEvents) => _getListItemHeight(bandWithEvents.events.length));

  String _getAlphabeticalIndex(int index) => bands[index].map((band) {
        final letter = band.bandName.substring(0, 1);
        // TODO(SF) THEME use different symbol?
        return _isLetterRegex.hasMatch(letter) ? letter : '#';
      }).orElse('');

  Widget _buildListItem(int index, DateTime currentTime) => bands[index]
      .map<Widget>((bandWithEvents) => BandListItem(
            key: Key(bandWithEvents.bandName),
            bandWithEvents: bandWithEvents,
            currentTime: currentTime,
          ))
      .orElse(Container());

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    return AlphabeticalListView(
      itemCount: bands.length,
      listItemHeights: _calculateListItemHeights(),
      getAlphabeticalIndex: _getAlphabeticalIndex,
      buildListItem: (_, index) => _buildListItem(index, currentTime),
    );
  }
}
