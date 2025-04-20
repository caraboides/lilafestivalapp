import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:optional/optional.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/app_route.dart';
import '../../models/global_config.dart';
import '../../models/theme.dart';
import '../../services/navigation.dart';
import '../../widgets/optional_builder.dart';
import 'menu.i18n.dart';

class Menu extends StatelessWidget {
  const Menu();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  Navigation get _navigation => dimeGet<Navigation>();
  GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  Widget _buildEntryTitle(
    ThemeData theme,
    String label, {
    bool isCurrentRoute = false,
  }) => Text(
    label,
    style: theme.textTheme.headlineMedium?.copyWith(
      color: isCurrentRoute ? theme.colorScheme.onSurface : null,
    ),
  );

  Widget _buildEntry({
    required ThemeData theme,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isCurrentRoute = false,
  }) => ListTile(
    title: _buildEntryTitle(theme, label, isCurrentRoute: isCurrentRoute),
    leading: IconTheme(
      data: theme.iconTheme,
      child: Icon(
        icon,
        color: isCurrentRoute ? theme.colorScheme.onSurface : null,
      ),
    ),
    onTap: onTap,
  );

  Widget _buildNestedEntry({
    required BuildContext context,
    required NavigatorState navigator,
    required ThemeData theme,
    required NestedAppRoute route,
    required String currentRoutePath,
  }) => ExpansionTile(
    title: _buildEntryTitle(theme, route.getName()),
    leading: IconTheme(data: theme.iconTheme, child: Icon(route.icon)),
    initiallyExpanded: currentRoutePath.contains(route.path),
    children:
        route.nestedRoutes.map((nestedRoute) {
          final path = route.nestedRoutePath(nestedRoute);
          return ListTile(
            title: _buildEntryTitle(
              theme,
              nestedRoute.title,
              isCurrentRoute: path == currentRoutePath,
            ),
            leading: const SizedBox(width: 24),
            onTap: () => _navigation.navigateToPath(navigator, path),
          );
        }).toList(),
  );

  Widget _buildEntries(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    final locale = I18n.locale;
    final currentRoute = _navigation.routeObserver.currentRoute;
    return ListView(
      children: <Widget>[
        OptionalBuilder(
          optional: Optional.of(_theme.logoMenu),
          builder: (_, logoMenu) => (logoMenu as Logo).toAsset(),
        ),
        ..._navigation.routes.map(
          (route) =>
              route is NestedAppRoute
                  ? _buildNestedEntry(
                    context: context,
                    navigator: navigator,
                    theme: theme,
                    route: route,
                    currentRoutePath: currentRoute,
                  )
                  : _buildEntry(
                    theme: theme,
                    label: route.getName(),
                    icon: route.icon,
                    onTap: () => _navigation.navigateToRoute(navigator, route),
                    isCurrentRoute: route.path == currentRoute,
                  ),
        ),
        _buildEntry(
          theme: theme,
          label: 'Privacy Policy'.i18n,
          icon: Icons.verified_user,
          onTap:
              () => launchUrl(
                locale.languageCode == 'de'
                    ? _globalConfig.privacyPolicyUrlDe
                    : _globalConfig.privacyPolicyUrlEn,
                mode: LaunchMode.externalApplication,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext _) => Theme(
    data: _theme.menuTheme,
    child: Builder(
      builder:
          (context) => Drawer(
            child: Container(
              decoration: _theme.menuDrawerDecoration,
              child: _buildEntries(context),
            ),
          ),
    ),
  );
}
