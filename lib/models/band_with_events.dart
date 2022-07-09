import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import 'band.dart';
import 'event.dart';

class BandWithEvents {
  const BandWithEvents({
    required this.band,
    required this.events,
    required this.bandName,
  });

  final String bandName;
  final Optional<Band> band;
  final ImmortalList<Event> events;

  bool isPlaying(DateTime currentTime) =>
      events.any((event) => event.isPlaying(currentTime));
}
