import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../screens/about/about.dart';
import '../screens/schedule/schedule.dart';

class AppRoute {
  const AppRoute({
    this.path,
    this.name,
    this.icon,
    this.isRoot = false,
    this.builder,
  });

  final String path;
  final String name;
  final IconData icon;
  final bool isRoot;
  final WidgetBuilder builder;
}

final ImmortalList<AppRoute> routes = ImmortalList([
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
  AppRoute(
    path: '/drive',
    name: 'Location',
    icon: Icons.map,
    // builder: Drive.builder,
  ),
  AppRoute(
    path: '/faq',
    name: 'FAQ',
    icon: Icons.help,
    // builder: FAQ.builder,
  ),
  AppRoute(
    path: '/about',
    name: 'About',
    icon: Icons.info,
    builder: About.builder,
  ),
]);
final ImmortalMap<String, AppRoute> routesByPath =
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
