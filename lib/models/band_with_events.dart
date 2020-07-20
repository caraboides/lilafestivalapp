import 'package:flutter/foundation.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../utils/band_key.dart';
import 'band.dart';
import 'event.dart';

class BandWithEvents {
  const BandWithEvents({
    @required this.festivalId,
    @required this.band,
    @required this.events,
    @required this.bandName,
  });

  final String festivalId;
  final String bandName;
  final Optional<Band> band;
  final ImmortalList<Event> events;

  BandKey get bandKey => BandKey(
        festivalId: festivalId,
        bandName: bandName,
      );

  bool isPlaying(DateTime currentTime) =>
      events.any((event) => event.isPlaying(currentTime));
}
