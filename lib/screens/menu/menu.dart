import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dime/dime.dart';

import '../../models/global_config.dart';
import '../../models/theme.dart';
import '../../services/navigation.dart';
import 'menu.i18n.dart';

class Menu extends StatelessWidget {
  const Menu();

  Widget _buildEntry({
    FestivalTheme theme,
    String label,
    IconData icon,
    VoidCallback onTap,
  }) =>
      ListTile(
        title: Text(
          label.i18n,
          style: theme.menuEntryTextStyle,
        ),
        leading: Icon(
          icon,
          color: theme.menuIconColor,
        ),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = dimeGet<FestivalTheme>();
    final config = dimeGet<GlobalConfig>();
    final navigation = dimeGet<Navigation>();
    return Drawer(
      child: Container(
        decoration: theme.menuDrawerDecoration,
        child: ListView(
          children: <Widget>[
            // Image.asset(
            //   'assets/icon_menu.png',
            //   height: 300,
            // ),
            ...navigation.routes
                .map((route) => _buildEntry(
                      theme: theme,
                      label: route.name,
                      icon: route.icon,
                      onTap: () => navigation.navigateToRoute(navigator, route),
                    ))
                .toMutableList(),
            _buildEntry(
              theme: theme,
              label: 'Privacy Policy',
              icon: Icons.verified_user,
              onTap: () => launch(config.privacyPolicyUrl),
            ),
          ],
        ),
      ),
    );
  }
}
