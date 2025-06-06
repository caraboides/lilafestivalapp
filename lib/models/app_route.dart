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
    this.isRoot = false,
  });

  final String path;
  final ValueGetter<String> getName;
  final IconData icon;
  final bool isRoot;
}

class FlatAppRoute extends AppRoute {
  const FlatAppRoute({
    required super.path,
    required super.getName,
    required super.icon,
    required this.builder,
    super.isRoot,
  });

  final WidgetBuilder builder;
}

class NestedAppRoute extends AppRoute {
  const NestedAppRoute({
    required super.path,
    required super.getName,
    required super.icon,
    required this.nestedRouteBuilder,
    required this.nestedRoutes,
    super.isRoot,
  });

  final NestedRouteBuilder nestedRouteBuilder;
  final ImmortalList<NestedRoute> nestedRoutes;

  String nestedRoutePath(NestedRoute nestedRoute) => '$path/${nestedRoute.key}';
}
