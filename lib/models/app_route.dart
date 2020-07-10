import 'package:flutter/material.dart';

class AppRoute {
  const AppRoute({
    this.path,
    this.getName,
    this.icon,
    this.isRoot = false,
    this.builder,
  });

  final String path;
  final ValueGetter<String> getName;
  final IconData icon;
  final bool isRoot;
  final WidgetBuilder builder;
}
