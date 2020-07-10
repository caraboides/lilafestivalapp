import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import 'app_route.dart';
import 'lat_lng.dart';
import 'reference.dart';

// TODO(SF) add required annotations or similiar
class FestivalConfig {
  const FestivalConfig({
    this.festivalId,
    this.festivalName,
    this.festivalFullName,
    this.festivalUrl,
    this.startDate,
    this.endDate,
    this.daySwitchOffset,
    this.fontReferences,
    this.aboutMessages,
    this.stageAlignment,
    this.routes,
    this.weatherGeoLocation,
    this.weatherCityId,
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
