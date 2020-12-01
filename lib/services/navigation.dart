import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../screens/about/about.dart';
import '../screens/history/history.dart';
import '../screens/schedule/schedule.dart';

class Navigation {
  const Navigation();

  FestivalConfig get _config => dimeGet<FestivalConfig>();

  ImmortalList<AppRoute> get routes => ImmortalList([
        const AppRoute(
          path: '/',
          getName: ScheduleScreen.title,
          icon: Icons.calendar_today,
          isRoot: true,
          builder: ScheduleScreen.builder,
        ),
        const AppRoute(
          path: '/mySchedule',
          getName: ScheduleScreen.myScheduleTitle,
          icon: Icons.star,
          isRoot: true,
          builder: ScheduleScreen.myScheduleBuilder,
        ),
        ..._config.routes.toMutableList(),
        if (_config.history.isNotEmpty)
          AppRoute(
            path: '/history',
            getName: History.title,
            icon: Icons.history,
            nestedRoutes: _config.history,
            nestedRouteBuilder: History.builder,
          ),
        const AppRoute(
          path: '/about',
          getName: About.title,
          icon: Icons.info,
          builder: About.builder,
        ),
      ]);

  ImmortalMap<String, AppRoute> get _routesByPath =>
      routes.asMapWithKeys((route) => route.path);

  ImmortalMap<String, WidgetBuilder> _buildNestedNamedRoutes(AppRoute route) =>
      route.nestedRoutes.asMapWithKeys(route.nestedRoutePath).mapValues(
          (_, nestedRoute) =>
              (context) => route.nestedRouteBuilder(context, nestedRoute));

  ImmortalMap<String, WidgetBuilder> _buildNamedRoutes(
          String routePath, AppRoute route) =>
      route.isNested
          ? _buildNestedNamedRoutes(route)
          : ImmortalMap({
              routePath: (context) => route.isRoot
                  ? I18n(child: route.builder(context))
                  : route.builder(context),
            });

  ImmortalMap<String, WidgetBuilder> get namedRoutes =>
      _routesByPath.mapValues(_buildNamedRoutes).flatten();

  bool _isRoot(Route route) => _routesByPath[route.settings.name]
      .map((appRoute) => appRoute.isRoot)
      .orElse(false);

  void navigateToPath(NavigatorState navigator, String path) {
    navigator.pop();
    navigator.pushNamedAndRemoveUntil(path, _isRoot);
  }

  void navigateToRoute(NavigatorState navigator, AppRoute route) {
    if (route.isRoot) {
      navigator.popUntil(_isRoot);
      navigator.pushReplacementNamed(route.path);
    } else {
      navigateToPath(navigator, route.path);
    }
  }
}
