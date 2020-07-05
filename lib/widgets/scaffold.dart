import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/theme.dart';
import '../screens/menu/menu.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    this.title,
    this.appBar,
    this.body,
    this.backgroundColor,
  });

  final String title;
  final AppBar appBar;
  final Widget body;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const Menu(),
        appBar: appBar ?? dimeGet<FestivalTheme>().appBar(title),
        backgroundColor: backgroundColor,
        body: body,
      );
}
