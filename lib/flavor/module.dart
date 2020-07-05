import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/festival_config.dart';
import '../models/theme.dart';

final FestivalConfig config = FestivalConfig(
  festivalName: 'Test festival',
  startDate: DateTime(2019, 8, 29),
  endDate: DateTime(2019, 8, 31),
  daySwitchOffset: Duration(hours: 3),
);

final ThemeData theme = ThemeData(
  primaryColor: Color(0xFF15928c),
  accentColor: Color(0xFFbafb00),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final Color menuBackgroundColor = Colors.grey[850];
final Color dividerColor = Colors.grey[800];
final Color menuFontColor = Color(0xFFd6102b);
final Color menuIconColor = menuFontColor.withOpacity(0.87);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  tabTextStyle: TextStyle(
    fontFamily: 'No Continue',
    fontSize: 18,
  ),
  menuEntryTextStyle: theme.textTheme.headline6.copyWith(
    color: menuFontColor,
  ),
  menuDrawerDecoration: BoxDecoration(
    border: Border(
      right: BorderSide(width: 2, color: Colors.black),
    ),
    color: menuBackgroundColor,
  ),
  menuIconColor: menuIconColor,
);

class FlavorModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<FestivalConfig>(config);
    addSingle<FestivalTheme>(festivalTheme);
  }
}
