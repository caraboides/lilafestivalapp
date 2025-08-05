import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../models/theme.dart';
import '../../widgets/menu/menu.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  @override
  Widget build(BuildContext context) => Theme(
    data: _theme.menuTheme,
    child: Builder(builder: (innerContext) => const Drawer(child: Menu())),
  );
}
