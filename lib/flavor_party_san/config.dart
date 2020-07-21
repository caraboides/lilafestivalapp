import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/lat_lng.dart';
import '../models/reference.dart';
import 'screens/faq/faq.dart';
import 'screens/shuttle/shuttle.dart';

final FestivalConfig config = FestivalConfig(
  festivalId: 'party_san_2021',
  festivalName: 'Party.San',
  festivalFullName: 'Party.San Open Air',
  festivalUrl: 'https://www.party-san.de',
  startDate: DateTime(2021, 8, 12),
  endDate: DateTime(2021, 8, 14),
  daySwitchOffset: const Duration(hours: 3),
  fontReferences: ImmortalList([
    Reference(
      label: 'Pirata One',
      links: ImmortalList([
        const Link(
          url: 'http://www.rfuenzalida.com/',
          label: 'Rodrigo Fuenzalida',
        ),
      ]),
    ),
  ]),
  aboutMessages: ImmortalList([
    Reference(
      links: ImmortalList([
        const Link(
          imageAssetPath: 'assets/mar.gif',
          url: 'http://www.metalheadsagainstracism.org/',
        ),
      ]),
    ),
  ]),
  stageAlignment: (stage) =>
      stage == 'Mainstage' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
  routes: ImmortalList([
    AppRoute(
      path: '/shuttle',
      getName: Shuttle.title,
      icon: Icons.map,
      builder: Shuttle.builder,
    ),
    AppRoute(
      path: '/faq',
      getName: FAQ.title,
      icon: Icons.help,
      builder: FAQ.builder,
    ),
  ]),
  weatherGeoLocation: const LatLng(lat: 51.25, lng: 10.67),
  weatherCityId: '2838240',
  history: ImmortalList([
    const NestedRoute(key: 'party_san_2019', title: '2019'),
  ]),
);
