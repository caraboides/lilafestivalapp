import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/theme.dart';
import '../screens/menu/menu.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold._({
    required this.body,
    this.title,
    this.appBar,
    this.isDialog = false,
  }) : assert(title != null || appBar != null, 'title or app bar required');

  factory AppScaffold.forDialog({
    required Widget body,
    required String title,
  }) => AppScaffold._(body: body, title: title, isDialog: true);

  factory AppScaffold.withTitle({
    required Widget body,
    required String title,
  }) => AppScaffold._(body: body, title: title);

  factory AppScaffold.withAppBar({
    required Widget body,
    required AppBar appBar,
  }) => AppScaffold._(body: body, appBar: appBar);

  final String? title;
  final AppBar? appBar;
  final Widget body;
  final bool isDialog;

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: isDialog ? null : const Menu(),
    appBar: appBar ?? dimeGet<FestivalTheme>().appBar(title!),
    body: body,
  );
}
