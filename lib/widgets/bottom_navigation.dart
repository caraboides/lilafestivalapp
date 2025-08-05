import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../services/navigation.dart';

class BottomNavigation extends StatelessWidget {
  Navigation get _navigation => dimeGet<Navigation>();

  @override
  Widget build(BuildContext context) => NavigationBar(
    onDestinationSelected: (int index) {
      if (index < 0 || index >= _navigation.bottomBarRoutes.length) {
        return;
      }
      _navigation.bottomBarRoutes[index].ifPresent((route) {
        _navigation.routeObserver.selectedBottomBarIndex = index;
        _navigation.navigateToRoute(Navigator.of(context), route);
      });
    },
    selectedIndex: _navigation.routeObserver.selectedBottomBarIndex,
    destinations: _navigation.bottomBarRoutes
        .map(
          (route) => NavigationDestination(
            icon: Icon(route.icon),
            selectedIcon: Icon(route.selectedIcon),
            label: route.getName(),
          ),
        )
        .toList(),
  );
}
