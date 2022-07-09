import 'dart:math';

import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

class MySchedule {
  const MySchedule._(this._eventsWithNotification);

  factory MySchedule.empty() => MySchedule._(ImmortalMap<String, int>.empty());

  factory MySchedule.fromJson(Map<String, dynamic> json) =>
      MySchedule._(ImmortalMap(json.cast<String, int>()));

  final ImmortalMap<String, int> _eventsWithNotification;

  bool isEventLiked(String eventId) =>
      _eventsWithNotification.containsKey(eventId);

  Optional<int> getNotificationId(String eventId) =>
      _eventsWithNotification.get(eventId);

  MySchedule _add(String eventId, int notificationId) =>
      MySchedule._(_eventsWithNotification.add(eventId, notificationId));

  MySchedule _remove(String eventId) =>
      MySchedule._(_eventsWithNotification.remove(eventId));

  int _nextNotificationId() => _eventsWithNotification.values.fold(0, max) + 1;

  MySchedule toggleEvent(
    String eventId, {
    required ValueChanged<int> onAdd,
    required ValueChanged<int> onRemove,
  }) =>
      getNotificationId(eventId).map((notificationId) {
        onRemove(notificationId);
        return _remove(eventId);
      }).orElseGet(() {
        final notificationId = _nextNotificationId();
        onAdd(notificationId);
        return _add(eventId, notificationId);
      });

  Map<String, int> toJson() => _eventsWithNotification.toMap();

  bool get isEmpty => _eventsWithNotification.isEmpty;
}
