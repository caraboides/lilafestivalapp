import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/lat_lng.dart';
import '../models/reference.dart';
import 'model/history_items.dart';
import 'screens/rules/rules.dart';
import 'screens/shuttle/shuttle.dart';
import 'screens/webview/WebViewScreen.dart';

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
      ]),
    ),
  ]),
  stageAlignment:
      (stage) =>
          stage == 'Shows'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
  routes: ImmortalList([
    FlatAppRoute(
      path: Shuttle.path,
      getName: Shuttle.title,
      icon: Icons.location_city,
      builder: Shuttle.builder,
    ),
    FlatAppRoute(
      path: Rules.path,
      getName: Rules.title,
      icon: Icons.gavel,
      builder: Rules.builder,
    )
  ]),
  nestedRoutes: ImmortalList([
    NestedAppRoute(
      path: '/history',
      getName: () => 'History',
      icon: Icons.history,
      nestedRoutes: ImmortalList([
        BuiltNestedRoute(
          key: '2023',
          title: historyItems[0].title,
          builder: (context) => WebViewScreen(item: historyItems[0]),
        ),
        BuiltNestedRoute(
          key: '2024',
          title: historyItems[1].title,
          builder: (context) => WebViewScreen(item: historyItems[1]),
        ),
      ]),
      nestedRouteBuilder: (context, route) {
        if (route is BuiltNestedRoute) {
          return route.builder(context);
        }
        return const Scaffold(body: Center(child: Text('Kein Builder')));
      },
    ),
  ]),
  weatherGeoLocation: const LatLng(lat: 53.54, lng: 9.95),
  weatherCityId: '2911298',
  history: ImmortalList([

  ]),
);
