import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

class NestedRoute {
  const NestedRoute({
    @required this.key,
    @required this.title,
  });

  final String key;
  final String title;
}

typedef NestedRouteBuilder = Widget Function(
  BuildContext context,
  NestedRoute nestedRoute,
);

class AppRoute {
  const AppRoute({
    @required this.path,
    @required this.getName,
    @required this.icon,
    this.builder,
    this.nestedRouteBuilder,
    this.nestedRoutes,
    this.isRoot = false,
  }) : assert(builder != null ||
            (nestedRoutes != null && nestedRouteBuilder != null));

  final String path;
  final ValueGetter<String> getName;
  final IconData icon;
  final bool isRoot;
  final WidgetBuilder builder;
  final NestedRouteBuilder nestedRouteBuilder;
  final ImmortalList<NestedRoute> nestedRoutes;

  bool get isNested => nestedRoutes != null && nestedRouteBuilder != null;

  String nestedRoutePath(NestedRoute nestedRoute) => '$path/${nestedRoute.key}';
}
