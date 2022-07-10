import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../../models/band_with_events.dart';
import '../../../providers/festival_scope.dart';

import 'band_cancelled.i18n.dart';

class BandCancelled extends StatelessWidget {
  const BandCancelled(this.bandWithEvents);

  final BandWithEvents bandWithEvents;

  @override
  Widget build(BuildContext context) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    return Visibility(
      visible: festivalScope is HistoryFestivalScope &&
              bandWithEvents.events.isEmpty ||
          bandWithEvents.band.map((band) => band.cancelled).orElse(false),
      child: Text(
        'CANCELLED'.i18n,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
