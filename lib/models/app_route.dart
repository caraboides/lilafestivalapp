import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

class NestedRoute {
  const NestedRoute({
    required this.key,
    required this.title,
  });

  final String key;
  final String title;
}

typedef NestedRouteBuilder = Widget Function(
  BuildContext context,
  NestedRoute nestedRoute,
);

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
    required String path,
    required ValueGetter<String> getName,
    required IconData icon,
    required this.builder,
    bool isRoot = false,
  }) : super(
          path: path,
          getName: getName,
          icon: icon,
          isRoot: isRoot,
        );

  final WidgetBuilder builder;
}

class NestedAppRoute extends AppRoute {
  const NestedAppRoute({
    required String path,
    required ValueGetter<String> getName,
    required IconData icon,
    required this.nestedRouteBuilder,
    required this.nestedRoutes,
    bool isRoot = false,
  }) : super(
          path: path,
          getName: getName,
          icon: icon,
          isRoot: isRoot,
        );

  final NestedRouteBuilder nestedRouteBuilder;
  final ImmortalList<NestedRoute> nestedRoutes;

  String nestedRoutePath(NestedRoute nestedRoute) => '$path/${nestedRoute.key}';
}
