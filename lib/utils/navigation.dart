import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../screens/home.dart';

class AppRoute {
  const AppRoute({
    this.path,
    this.name,
    this.icon,
    this.isHomeRoute = false,
    this.builder,
  });

  final String path;
  final String name;
  final IconData icon;
  final bool isHomeRoute;
  final WidgetBuilder builder;
}

final ImmortalList<AppRoute> routes = ImmortalList([
  AppRoute(
    path: '/',
    name: 'Schedule',
    icon: Icons.calendar_today,
    isHomeRoute: true,
    builder: HomeScreen.builder,
  ),
  AppRoute(
    path: '/mySchedule',
    name: 'My Schedule',
    icon: Icons.star,
    isHomeRoute: true,
    builder: HomeScreen.myScheduleBuilder,
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
    // builder: About.builder,
  ),
]);
final ImmortalMap<String, AppRoute> routesByPath =
    routes.asMapWithKeys((route) => route.path);

bool _isHomeScreen(Route route) => routesByPath[route.settings.name]
    .map((appRoute) => appRoute.isHomeRoute)
    .orElse(false);

void navigateToRoute(NavigatorState navigator, AppRoute route) {
  if (route.isHomeRoute) {
    navigator.popUntil(_isHomeScreen);
    navigator.pushReplacementNamed(route.path);
  } else {
    navigator.pop();
    navigator.pushNamedAndRemoveUntil(
      route.path,
      _isHomeScreen,
    );
  }
}
