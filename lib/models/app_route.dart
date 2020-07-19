import 'package:flutter/material.dart';

class AppRoute {
  const AppRoute({
    @required this.path,
    @required this.getName,
    @required this.icon,
    @required this.builder,
    this.isRoot = false,
  });

  final String path;
  final ValueGetter<String> getName;
  final IconData icon;
  final bool isRoot;
  final WidgetBuilder builder;
}
