import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/band_with_events.dart';
import '../../models/theme.dart';
import '../../providers/festival_scope.dart';

import 'band_cancelled.i18n.dart';

class BandCancelled extends StatelessWidget {
  const BandCancelled(this.bandWithEvents, {this.fallback});

  final BandWithEvents bandWithEvents;
  final Widget fallback;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  @override
  Widget build(BuildContext context) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    if (!festivalScope.isCurrentFestival && bandWithEvents.events.isEmpty ||
        bandWithEvents.band.map((band) => band.cancelled).orElse(false)) {
      return Text(
        'CANCELLED'.i18n,
        style: _theme.theme.textTheme.headline6,
      );
    }
    return fallback ?? Container();
  }
}
