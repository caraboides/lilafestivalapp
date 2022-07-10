import 'dart:math';

import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import 'ids.dart';

class MySchedule {
  const MySchedule._(this._eventsWithNotification);

  factory MySchedule.empty() =>
      MySchedule._(ImmortalMap<EventId, NotificationId>.empty());

  factory MySchedule.fromJson(Map<String, dynamic> json) =>
      MySchedule._(ImmortalMap(json.cast<EventId, NotificationId>()));

  final ImmortalMap<EventId, NotificationId> _eventsWithNotification;

  bool isEventLiked(EventId eventId) =>
      _eventsWithNotification.containsKey(eventId);

  Optional<NotificationId> getNotificationId(EventId eventId) =>
      _eventsWithNotification.get(eventId);

  MySchedule _add(EventId eventId, NotificationId notificationId) =>
      MySchedule._(_eventsWithNotification.add(eventId, notificationId));

  MySchedule _remove(EventId eventId) =>
      MySchedule._(_eventsWithNotification.remove(eventId));

  NotificationId _nextNotificationId() =>
      _eventsWithNotification.values.fold(0, max) + 1;

  MySchedule toggleEvent(
    EventId eventId, {
    required ValueChanged<NotificationId> onAdd,
    required ValueChanged<NotificationId> onRemove,
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
