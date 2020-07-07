import 'package:flutter/material.dart';

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
