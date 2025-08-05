import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

class NestedRoute {
  const NestedRoute({required this.key, required this.title});

  final String key;
  final String title;
}

typedef NestedRouteBuilder =
    Widget Function(BuildContext context, NestedRoute nestedRoute);

abstract class AppRoute {
  const AppRoute({
    required this.path,
    required this.getName,
    required this.icon,
    required this.selectedIcon,
    this.isRoot = false,
    this.inBottomNavigation = false,
    this.inMenu = false,
    this.inMore = false,
  });

  final String path;
  final ValueGetter<String> getName;
  final IconData icon;
  final IconData selectedIcon;
  final bool isRoot;
  final bool inBottomNavigation;
  final bool inMenu;
  final bool inMore;
}

class FlatAppRoute extends AppRoute {
  const FlatAppRoute({
    required super.path,
    required super.getName,
    required super.icon,
    required super.selectedIcon,
    required this.builder,
    super.isRoot,
    super.inBottomNavigation,
    super.inMenu,
    super.inMore,
  });

  final WidgetBuilder builder;
}

class NestedAppRoute extends AppRoute {
  const NestedAppRoute({
    required super.path,
    required super.getName,
    required super.icon,
    required super.selectedIcon,
    required this.nestedRouteBuilder,
    required this.nestedRoutes,
    super.isRoot,
    super.inBottomNavigation,
    super.inMenu,
    super.inMore,
  });

  final NestedRouteBuilder nestedRouteBuilder;
  final ImmortalList<NestedRoute> nestedRoutes;

  String nestedRoutePath(NestedRoute nestedRoute) => '$path/${nestedRoute.key}';
}
