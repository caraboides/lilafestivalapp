import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/models/app_route.dart';
import 'package:lilafestivalapp/models/event.dart';
import 'package:lilafestivalapp/models/festival_config.dart';
import 'package:lilafestivalapp/models/lat_lng.dart';
import 'package:optional/optional.dart';

final testFestivalConfig = FestivalConfig(
  festivalId: 'festival_id_2025',
  festivalName: 'name',
  festivalFullName: 'full_name',
  festivalUrl: Uri.parse('https://www.example.com'),
  startDate: DateTime(2025, 2, 23),
  endDate: DateTime(2025, 2, 25),
  daySwitchOffset: const Duration(hours: 3),
  fontReferences: ImmortalList.empty(),
  aboutMessages: ImmortalList.empty(),
  stageAlignment: (_) => CrossAxisAlignment.start,
  routes: ImmortalList.empty(),
  weatherGeoLocation: const LatLng(lat: 1, lng: 1),
  weatherCityId: 'weatherCityId',
  history: ImmortalList.of([
    const NestedRoute(key: 'festival_id_2024', title: '2024'),
  ]),
);

ImmortalList<Event> createBandEvents({String bandName = 'band1'}) =>
    ImmortalList.of([
      testFestivalConfig.startDate.add(const Duration(hours: 2)),
      testFestivalConfig.startDate.add(const Duration(hours: 4)),
      testFestivalConfig.startDate.add(const Duration(days: 1)),
    ]).mapIndexed(
      (index, startDate) => Event(
        bandName: bandName,
        id: 'event$index',
        stage: 'stage',
        start: Optional.of(startDate),
        end: Optional.of(startDate.add(const Duration(hours: 1))),
      ),
    );
