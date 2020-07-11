import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dime/dime.dart';

import '../../models/global_config.dart';
import '../../models/theme.dart';
import '../../services/navigation.dart';
import 'menu.i18n.dart';

class Menu extends StatelessWidget {
  const Menu();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  Navigation get _navigation => dimeGet<Navigation>();
  GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  Widget _buildEntry({
    ThemeData theme,
    String label,
    IconData icon,
    VoidCallback onTap,
  }) =>
      ListTile(
        title: Text(
          label,
          style: theme.textTheme.headline4,
        ),
        leading: IconTheme(
          data: theme.iconTheme,
          child: Icon(icon),
        ),
        onTap: onTap,
      );

  Widget _buildEntries(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    return ListView(
      children: <Widget>[
        if (_theme.logoMenu != null)
          Image.asset(
            _theme.logoMenu.assetPath,
            height: _theme.logoMenu.height,
            width: _theme.logoMenu.width,
          ),
        ..._navigation.routes
            .map((route) => _buildEntry(
                  theme: theme,
                  label: route.getName(),
                  icon: route.icon,
                  onTap: () => _navigation.navigateToRoute(navigator, route),
                ))
            .toMutableList(),
        _buildEntry(
          theme: theme,
          label: 'Privacy Policy'.i18n,
          icon: Icons.verified_user,
          onTap: () => launch(locale.languageCode == 'de'
              ? _globalConfig.privacyPolicyUrlDe
              : _globalConfig.privacyPolicyUrlEn),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext _) => Theme(
        data: _theme.menuTheme,
        child: Builder(
          builder: (context) => Drawer(
            child: Container(
              decoration: _theme.menuDrawerDecoration,
              child: _buildEntries(context),
            ),
          ),
        ),
      );
}
