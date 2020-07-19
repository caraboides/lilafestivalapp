import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/theme.dart';
import '../screens/menu/menu.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    @required this.body,
    this.title,
    this.appBar,
    this.isDialog = false,
  }) : assert(title != null || appBar != null);

  final String title;
  final AppBar appBar;
  final Widget body;
  final bool isDialog;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: isDialog ? null : const Menu(),
        appBar: appBar ?? dimeGet<FestivalTheme>().appBar(title),
        body: body,
      );
}
