import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import 'app_route.dart';
import 'lat_lng.dart';
import 'reference.dart';

class FestivalConfig {
  const FestivalConfig({
    @required this.festivalId,
    @required this.festivalName,
    @required this.festivalFullName,
    @required this.festivalUrl,
    @required this.startDate,
    @required this.endDate,
    @required this.daySwitchOffset,
    @required this.fontReferences,
    @required this.aboutMessages,
    @required this.stageAlignment,
    @required this.routes,
    @required this.weatherGeoLocation,
    @required this.weatherCityId,
  });

  final String festivalId;
  final String festivalName;
  final String festivalFullName;
  final String festivalUrl;
  final DateTime startDate;
  final DateTime endDate;
  final Duration daySwitchOffset;
  final ImmortalList<Reference> fontReferences;
  final ImmortalList<Reference> aboutMessages;
  final CrossAxisAlignment Function(String stage) stageAlignment;
  final ImmortalList<AppRoute> routes;
  final LatLng weatherGeoLocation;
  final String weatherCityId;

  ImmortalList<DateTime> get days => ImmortalList.generate(
      endDate.difference(startDate).inDays + 1,
      (index) => DateTime(
            startDate.year,
            startDate.month,
            startDate.day + index,
          ));
}
