import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/lat_lng.dart';
import '../models/reference.dart';
import 'screens/faq/faq.dart';
import 'screens/shuttle/shuttle.dart';

final FestivalConfig config = FestivalConfig(
  festivalId: 'wtjt_2025',
  festivalName: 'WTJT',
  festivalFullName: 'Weltturbojugendtage',
  festivalUrl: Uri.parse('https://www.weltturbojugendtage.de'),
  startDate: DateTime(2025, 8, 1),
  endDate: DateTime(2025, 8, 4),
  daySwitchOffset: const Duration(hours: 3),
  fontReferences: ImmortalList([
    Reference(
      label: 'Impacted 2.0',
      links: ImmortalList([
        Link(
          url: Uri.parse('https://www.dafont.com/profile.php?user=338435'),
          label: 'Phil Campbell [Foxy Fonts]',
        ),
      ]),
    ),
  ]),
  aboutMessages: ImmortalList([
    Reference(
      links: ImmortalList([
        Link(
          imageAssetPath: 'assets/mar.gif',
          url: Uri.parse('https://www.facebook.com/MetalHeadsAgainst/'),
        ),
      ]),
    ),
  ]),
  stageAlignment:
      (stage) =>
          stage == 'Mainstage'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
  routes: ImmortalList([
    FlatAppRoute(
      path: Shuttle.path,
      getName: Shuttle.title,
      icon: Icons.map,
      builder: Shuttle.builder,
    ),
    FlatAppRoute(
      path: FAQ.path,
      getName: FAQ.title,
      icon: Icons.help,
      builder: FAQ.builder,
    ),
  ]),
  weatherGeoLocation: const LatLng(lat: 51.25, lng: 10.67),
  weatherCityId: '2838240',
  history: ImmortalList([
    const NestedRoute(key: 'wtjt', title: '2025')
  ]),
);
