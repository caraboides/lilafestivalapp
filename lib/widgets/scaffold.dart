import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/theme.dart';
import '../screens/menu/menu.dart';

// TODO(SF) add variation for dialogs?
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    this.title,
    this.appBar,
    this.body,
  });

  final String title;
  final AppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const Menu(),
        appBar: appBar ?? dimeGet<FestivalTheme>().appBar(title),
        body: body,
      );
}
