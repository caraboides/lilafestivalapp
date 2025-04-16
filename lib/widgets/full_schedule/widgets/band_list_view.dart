import 'dart:math';

import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../../../models/band_with_events.dart';
import '../../../models/theme.dart';
import '../../../utils/date.dart';
import 'alphabetical_list_view.dart';
import 'band_list_item.dart';
import 'missing_schedule_banner/missing_schedule_banner.dart';

class BandListView extends StatelessWidget {
  const BandListView({
    required this.bands,
    required this.bandIds,
    this.scheduleMissing = false,
    super.key,
  });

  final ImmortalMap<String, BandWithEvents> bands;
  final ImmortalList<String> bandIds;
  final bool scheduleMissing;

  static final _isLetterRegex = RegExp(r'^[a-zA-Z]+$');

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  double _getListItemHeight(int numEvents) =>
      numEvents == 1
          ? _theme.eventListItemHeight
          : max(
            _theme.bandListHeaderHeight +
                (numEvents / 2).ceil() * _theme.denseEventListItemHeight,
            _theme.bandListItemMinHeight,
          );

  ImmortalList<double> _calculateListItemHeights() => bandIds.map(
    (bandName) => bands[bandName]
        .map(
          (bandWithEvents) => _getListItemHeight(bandWithEvents.events.length),
        )
        .orElse(0),
  );

  Optional<BandWithEvents> _bandAt(int index) => bandIds[index]
      .map((bandName) => bands[bandName])
      .orElse(const Optional<BandWithEvents>.empty());

  String _getAlphabeticalIndex(int index) => _bandAt(index)
      .map((band) {
        final letter = band.bandName.substring(0, 1);
        // TODO(SF): THEME use different symbol?
        return _isLetterRegex.hasMatch(letter) ? letter : '#';
      })
      .orElse('');

  Widget _buildListItem(String itemId, DateTime currentTime) => bands[itemId]
      .map<Widget>(
        (bandWithEvents) => BandListItem(
          key: Key(bandWithEvents.bandName),
          bandWithEvents: bandWithEvents,
          currentTime: currentTime,
        ),
      )
      .orElse(Container());

  @override
  Widget build(BuildContext context) {
    final currentTime = currentDate();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MissingScheduleBanner(),
        Flexible(
          fit: FlexFit.loose,
          child: AlphabeticalListView(
            itemCount: bandIds.length,
            itemIds: bandIds,
            listItemHeights: _calculateListItemHeights(),
            getAlphabeticalIndex: _getAlphabeticalIndex,
            buildListItem:
                ({
                  required context,
                  required animation,
                  required index,
                  required itemId,
                }) => _buildListItem(itemId, currentTime),
          ),
        ),
      ],
    );
  }
}
