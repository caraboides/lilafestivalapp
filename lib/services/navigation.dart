import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../screens/about/about.dart';
import '../screens/schedule/schedule.dart';

class Navigation {
  ImmortalList<AppRoute> get routes => ImmortalList([
        AppRoute(
          path: '/',
          name: 'Schedule',
          icon: Icons.calendar_today,
          isRoot: true,
          builder: ScheduleScreen.builder,
        ),
        AppRoute(
          path: '/mySchedule',
          name: 'My Schedule',
          icon: Icons.star,
          isRoot: true,
          builder: ScheduleScreen.myScheduleBuilder,
        ),
        ...dimeGet<FestivalConfig>().routes.toMutableList(),
        AppRoute(
          path: '/about',
          name: 'About',
          icon: Icons.info,
          builder: About.builder,
        ),
      ]);

  ImmortalMap<String, AppRoute> get routesByPath =>
      routes.asMapWithKeys((route) => route.path);

  bool _isRoot(Route route) => routesByPath[route.settings.name]
      .map((appRoute) => appRoute.isRoot)
      .orElse(false);

  void navigateToRoute(NavigatorState navigator, AppRoute route) {
    if (route.isRoot) {
      navigator.popUntil(_isRoot);
      navigator.pushReplacementNamed(route.path);
    } else {
      navigator.pop();
      navigator.pushNamedAndRemoveUntil(
        route.path,
        _isRoot,
      );
    }
  }
}
