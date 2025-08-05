import 'package:flutter/material.dart';

import '../../widgets/menu/menu.dart';
import '../../widgets/scaffold.dart';
import 'more.i18n.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen();

  static Widget builder(BuildContext context) => const MoreScreen();

  static String path = '/more';
  static String title() => 'More'.i18n;

  @override
  Widget build(BuildContext context) =>
      AppScaffold.withTitle(title: title(), body: const Menu(onlyInMore: true));
}
