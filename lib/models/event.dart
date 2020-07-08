class Event {
  Event({
    this.bandName,
    this.id,
    this.stage,
    this.start,
    this.end,
  });

  final String bandName;
  final String id;
  final String stage;
  final DateTime start;
  final DateTime end;

  factory Event.fromJson(String id, Map<String, dynamic> json) => Event(
        bandName: json['band'],
        id: id,
        stage: json['stage'],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
      );

  bool isPlaying(DateTime currentTime) =>
      !currentTime.isBefore(start) && !currentTime.isAfter(end);
}
