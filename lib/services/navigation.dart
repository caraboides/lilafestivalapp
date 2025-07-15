import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../screens/about/about.dart';
import '../screens/history/history.dart';
import '../screens/schedule/schedule.dart';

class CurrentRouteObserver extends RouteObserver<ModalRoute<void>> {
  List<String> routeStack = [];

  String get currentRoute => routeStack.isEmpty ? '/' : routeStack.last;

  void replaceCurrentRoute(String? newRoute) {
    _onPop();
    _onPush(newRoute);
  }

  void _onPop() {
    if (routeStack.isNotEmpty) {
      routeStack.removeLast();
    }
  }

  void _onPush(String? route) {
    if (route != null) {
      routeStack.add(route);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _onPop();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _onPush(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _onPop();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    replaceCurrentRoute(newRoute?.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    replaceCurrentRoute(topRoute.settings.name);
    super.didChangeTop(topRoute, previousTopRoute);
  }
}

class Navigation {
  factory Navigation() => Navigation._(CurrentRouteObserver());

  const Navigation._(this.routeObserver);

  final CurrentRouteObserver routeObserver;

  FestivalConfig get _config => dimeGet<FestivalConfig>();

  ImmortalList<AppRoute> get routes => ImmortalList([
    FlatAppRoute(
      path: ScheduleScreen.path,
      getName: ScheduleScreen.title,
      icon: Icons.calendar_today,
      isRoot: true,
      builder: ScheduleScreen.builder,
    ),
    FlatAppRoute(
      path: ScheduleScreen.mySchedulePath,
      getName: ScheduleScreen.myScheduleTitle,
      icon: Icons.star,
      isRoot: true,
      builder: ScheduleScreen.myScheduleBuilder,
    ),
    ..._config.routes,
    ..._config.nestedRoutes,
    if (_config.history.isNotEmpty)
      NestedAppRoute(
        path: History.path,
        getName: History.title,
        icon: Icons.history,
        nestedRoutes: _config.history,
        nestedRouteBuilder: History.builder,
      ),
    FlatAppRoute(
      path: About.path,
      getName: About.title,
      icon: Icons.info,
      builder: About.builder,
    ),
  ]);

  ImmortalMap<String, AppRoute> get _routesByPath =>
      routes.asMapWithKeys((route) => route.path);

  ImmortalMap<String, WidgetBuilder> _buildNestedNamedRoutes(
    NestedAppRoute route,
  ) => route.nestedRoutes
      .asMapWithKeys(route.nestedRoutePath)
      .mapValues(
        (_, nestedRoute) =>
            (context) => route.nestedRouteBuilder(context, nestedRoute),
      );

  ImmortalMap<String, WidgetBuilder> _buildFlatRoute(
    String routePath,
    FlatAppRoute route,
  ) => ImmortalMap({
    routePath:
        (context) => route.builder(context),
  });

  ImmortalMap<String, WidgetBuilder> _buildNamedRoutes(
    String routePath,
    AppRoute route,
  ) =>
      route is NestedAppRoute
          ? _buildNestedNamedRoutes(route)
          : _buildFlatRoute(routePath, route as FlatAppRoute);

  ImmortalMap<String, WidgetBuilder> get namedRoutes =>
      _routesByPath.mapValues(_buildNamedRoutes).flatten();

  bool _isRoot(Route route) => _routesByPath[route.settings.name]
      .map((appRoute) => appRoute.isRoot)
      .orElse(false);

  Future<void> navigateToPath(NavigatorState navigator, String path) async {
    navigator.pop();
    await navigator.pushNamedAndRemoveUntil(path, _isRoot);
  }

  Future<void> navigateToRoute(NavigatorState navigator, AppRoute route) async {
    if (route.isRoot) {
      navigator.popUntil(_isRoot);
      await navigator.pushReplacementNamed(route.path);
    } else {
      await navigateToPath(navigator, route.path);
    }
  }
}
