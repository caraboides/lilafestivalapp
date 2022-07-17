import 'package:optional/optional.dart';

import 'ids.dart';

class Event implements Comparable {
  Event({
    required this.bandName,
    required this.id,
    required this.stage,
    required this.start,
    required this.end,
  });

  factory Event.fromJson(String id, Map<String, dynamic> json) => Event(
        bandName: json['band'] ?? '',
        id: id,
        stage: json['stage'] ?? '',
        start: Optional.ofNullable(DateTime.tryParse(json['start'])),
        end: Optional.ofNullable(DateTime.tryParse(json['end'])),
      );

  final String bandName;
  final EventId id;
  final String stage;
  final Optional<DateTime> start;
  final Optional<DateTime> end;

  bool isPlaying(DateTime currentTime) =>
      start
          .map((startTime) => !currentTime.isBefore(startTime))
          .orElse(false) &&
      end.map(currentTime.isBefore).orElse(false);

  @override
  int compareTo(dynamic other) => other is Event
      ? other.start
          .map((otherStartTime) => start
              .map((startTime) => startTime.compareTo(otherStartTime))
              .orElse(1))
          .orElse(-1)
      : -1;

  bool isInFutureOf(DateTime currentTime) =>
      start.map(currentTime.isBefore).orElse(false);

  bool isPlayingOrInFutureOf(DateTime currentTime) =>
      isInFutureOf(currentTime) || end.map(currentTime.isBefore).orElse(false);
}
