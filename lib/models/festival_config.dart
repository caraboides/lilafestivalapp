import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../providers/festival_scope.dart';
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
    @required this.history,
  });

  final String festivalId;
  final String festivalName;
  final String festivalFullName;
  final String festivalUrl;
  // TODO(SF) THEME display those somewhere?
  final DateTime startDate;
  final DateTime endDate;
  final Duration daySwitchOffset;
  final ImmortalList<Reference> fontReferences;
  final ImmortalList<Reference> aboutMessages;
  final CrossAxisAlignment Function(String stage) stageAlignment;
  final ImmortalList<AppRoute> routes;
  final LatLng weatherGeoLocation;
  final String weatherCityId;
  final ImmortalList<NestedRoute> history;

  FestivalScope get currentFestivalScope => FestivalScope.current(festivalId);
}
