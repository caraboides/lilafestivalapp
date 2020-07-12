import 'package:optional/optional.dart';

class Event implements Comparable {
  Event({
    this.bandName,
    this.id,
    this.stage,
    this.start,
    this.end,
  });

  factory Event.fromJson(String id, Map<String, dynamic> json) => Event(
        bandName: json['band'] ?? '',
        id: id,
        stage: json['stage'] ?? '',
        start: Optional.ofNullable(DateTime.tryParse(json['start'])),
        end: Optional.ofNullable(DateTime.tryParse(json['end'])),
      );

  final String bandName;
  final String id;
  final String stage;
  final Optional<DateTime> start;
  final Optional<DateTime> end;

  bool isPlaying(DateTime currentTime) =>
      start
          .map((startTime) => !currentTime.isBefore(startTime))
          .orElse(false) &&
      end.map((endTime) => !currentTime.isAfter(endTime)).orElse(false);

  // TODO(SF) TEST
  @override
  int compareTo(dynamic other) => other is Event
      ? other.start
          .map((otherStartTime) => start
              .map((startTime) => startTime.compareTo(otherStartTime))
              .orElse(1))
          .orElse(-1)
      : -1;
}
