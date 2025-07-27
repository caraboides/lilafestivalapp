import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:quiver/core.dart' as quiver;

import 'ids.dart';

@immutable
class Event implements Comparable {
  const Event({
    required this.bandName,
    required this.id,
    required this.stage,
    required this.start,
    required this.end,
  });

  factory Event.fromJson(String id, Map<String, dynamic> json) => Event(
    bandName: json['band'] as String? ?? '',
    id: id,
    stage: json['stage'] as String? ?? '',
    start: Optional.ofNullable(
      DateTime.tryParse(json['start'] as String? ?? ''),
    ),
    end: Optional.ofNullable(DateTime.tryParse(json['end'] as String? ?? '')),
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
            .map(
              (otherStartTime) => start
                  .map((startTime) => startTime.compareTo(otherStartTime))
                  .orElse(1),
            )
            .orElse(-1)
      : -1;

  bool isInFutureOf(DateTime currentTime) =>
      start.map(currentTime.isBefore).orElse(false);

  bool isPlayingOrInFutureOf(DateTime currentTime) =>
      isInFutureOf(currentTime) || end.map(currentTime.isBefore).orElse(false);

  @override
  int get hashCode => quiver.hashObjects(<dynamic>[
    bandName.hashCode,
    id.hashCode,
    stage.hashCode,
    start.hashCode,
    end.hashCode,
  ]);

  @override
  bool operator ==(dynamic other) =>
      other is Event &&
      bandName == other.bandName &&
      id == other.id &&
      stage == other.stage &&
      start == other.start &&
      end == other.end;

  String get notificationPayload =>
      jsonEncode({'band': bandName, 'id': id, 'hash': hashCode});
}
