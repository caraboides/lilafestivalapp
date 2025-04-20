import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/lat_lng.dart';
import '../models/reference.dart';
import 'screens/faq/faq.dart';
import 'screens/shuttle/shuttle.dart';

final FestivalConfig config = FestivalConfig(
  festivalId: 'party_san_2025',
  festivalName: 'Party.San',
  festivalFullName: 'Party.San Open Air',
  festivalUrl: Uri.parse('https://www.party-san.de'),
  startDate: DateTime(2025, 8, 7),
  endDate: DateTime(2025, 8, 9),
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
    const FlatAppRoute(
      path: '/shuttle',
      getName: Shuttle.title,
      icon: Icons.map,
      builder: Shuttle.builder,
    ),
    const FlatAppRoute(
      path: '/faq',
      getName: FAQ.title,
      icon: Icons.help,
      builder: FAQ.builder,
    ),
  ]),
  weatherGeoLocation: const LatLng(lat: 51.25, lng: 10.67),
  weatherCityId: '2838240',
  history: ImmortalList([
    const NestedRoute(key: 'party_san_2024', title: '2024'),
    const NestedRoute(key: 'party_san_2023', title: '2023'),
    const NestedRoute(key: 'party_san_2022', title: '2022'),
    const NestedRoute(key: 'party_san_2019', title: '2019'),
  ]),
);
