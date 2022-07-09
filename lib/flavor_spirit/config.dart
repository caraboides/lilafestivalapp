import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/lat_lng.dart';
import '../models/reference.dart';
import 'screens/drive/drive.dart';
import 'screens/faq/faq.dart';

final FestivalConfig config = FestivalConfig(
  festivalId: 'spirit_2019',
  festivalName: 'Spirit',
  festivalFullName: 'Spirit Festival',
  festivalUrl: 'https://www.spirit-festival.com',
  startDate: DateTime(2019, 8, 29),
  endDate: DateTime(2019, 8, 31),
  daySwitchOffset: const Duration(hours: 3),
  fontReferences: ImmortalList([
    Reference(
      label: 'No Continue',
      links: ImmortalList([
        const Link(
          url: 'http://gomaricefont.web.fc2.com/',
          label: 'Goma Shin',
        ),
      ]),
    ),
  ]),
  aboutMessages: ImmortalList([
    Reference(
      label: 'Seenotrettung ist kein Verbrechen!',
      links: ImmortalList([
        const Link(url: 'https://sea-watch.org/'),
      ]),
    ),
  ]),
  stageAlignment: (stage) {
    switch (stage) {
      case 'Mainstage':
        return CrossAxisAlignment.start;
      case 'Stage II':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  },
  routes: ImmortalList([
    const FlatAppRoute(
      path: '/drive',
      getName: Drive.title,
      icon: Icons.map,
      builder: Drive.builder,
    ),
    const FlatAppRoute(
      path: '/faq',
      getName: FAQ.title,
      icon: Icons.help,
      builder: FAQ.builder,
    ),
  ]),
  weatherGeoLocation: const LatLng(lat: 51.59, lng: 12.59),
  weatherCityId: '6547727',
  history: ImmortalList([
    const NestedRoute(key: 'spirit_2019', title: '2019'),
  ]),
);
