import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../providers/festival_scope.dart';
import 'app_route.dart';
import 'ids.dart';
import 'lat_lng.dart';
import 'reference.dart';

class FestivalConfig {
  const FestivalConfig({
    required this.festivalId,
    required this.festivalName,
    required this.festivalFullName,
    required this.festivalUrl,
    required this.startDate,
    required this.endDate,
    required this.daySwitchOffset,
    required this.fontReferences,
    required this.aboutMessages,
    required this.stageAlignment,
    required this.routes,
    required this.nestedRoutes,
    required this.weatherGeoLocation,
    required this.weatherCityId,
    required this.history,
  });

  final FestivalId festivalId;
  final String festivalName;
  final String festivalFullName;
  final Uri festivalUrl;
  // TODO(SF): THEME display those somewhere?
  // TODO(SF): maybe sliver app bar? combine with "onboarding"!
  final DateTime startDate;
  final DateTime endDate;
  final Duration daySwitchOffset;
  final ImmortalList<Reference> fontReferences;
  final ImmortalList<Reference> aboutMessages;
  final CrossAxisAlignment Function(String stage) stageAlignment;
  final ImmortalList<AppRoute> routes;
  final ImmortalList<NestedAppRoute> nestedRoutes;
  final LatLng weatherGeoLocation;
  final String weatherCityId;
  final ImmortalList<NestedRoute> history;

  FestivalScope get currentFestivalScope => FestivalScope(festivalId);

  DateTime toFestivalDay(DateTime date) {
    final withoutOffset = date.subtract(daySwitchOffset);
    return DateTime(withoutOffset.year, withoutOffset.month, withoutOffset.day);
  }

  ImmortalList<DateTime> get festivalDays {
    final days = [startDate];
    final length = endDate.difference(startDate).inDays;
    for (var i = 0; i < length; i++) {
      final day = startDate.add(Duration(days: i + 1));
      days.add(day);
    }
    return ImmortalList(days);
  }
}
