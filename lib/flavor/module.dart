import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../models/config.dart';
import '../models/theme.dart';

final FestivalConfig config = FestivalConfig(
  festivalName: 'Test festival',
  startDate: DateTime(2019, 8, 29),
  endDate: DateTime(2019, 8, 31),
  daySwitchOffset: Duration(hours: 3),
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: ThemeData(
    primaryColor: Color(0xFF15928c),
    accentColor: Color(0xFFbafb00),
  ),
  tabTextStyle: TextStyle(
    fontFamily: 'No Continue',
    fontSize: 18,
  ),
);

class FlavorModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<FestivalConfig>(config);
    addSingle<FestivalTheme>(festivalTheme);
  }
}
