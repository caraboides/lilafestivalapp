import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/lat_lng.dart';
import '../models/reference.dart';
import 'screens/faq/faq.dart';
import 'screens/shuttle/shuttle.dart';

final FestivalConfig config = FestivalConfig(
  festivalId: 'party.san_2019',
  festivalName: 'Party.San',
  festivalFullName: 'Party.San Open Air',
  festivalUrl: 'https://www.party-san.de',
  startDate: DateTime(2019, 8, 8),
  endDate: DateTime(2019, 8, 10),
  daySwitchOffset: Duration(hours: 3),
  fontReferences: ImmortalList([
    Reference(
      label: 'Pirata One',
      links: ImmortalList([
        Link(
          url: 'http://www.rfuenzalida.com/',
          label: 'Rodrigo Fuenzalida',
        ),
      ]),
    ),
  ]),
  aboutMessages: ImmortalList([
    Reference(
      links: ImmortalList([
        Link(
          imageAssetPath: 'assets/party.san/mar.gif',
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
  weatherGeoLocation: LatLng(lat: 51.25, lng: 10.67),
  weatherCityId: '2838240',
);
