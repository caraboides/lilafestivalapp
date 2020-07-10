import 'package:flutter/material.dart';

import '../models/theme.dart';

final String displayFontFamily = 'Pirata One';

final ThemeData theme = ThemeData(
  primaryColor: Colors.grey[850],
  accentColor: Color(0xFFD2D522),
  textTheme: Typography.blackMountainView.copyWith(
    headline4: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 24,
      color: Colors.black,
    ),
    headline3: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 28,
      color: Colors.black,
    ),
    subtitle2: TextStyle(
      // TODO(SF) can be part of global theme
      fontWeight: FontWeight.bold,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    textTheme: Typography.whiteMountainView.copyWith(
      headline6: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 26,
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 18,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: displayFontFamily,
      fontSize: 18,
    ),
  ),
  cardTheme: CardTheme(
    margin: EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 1),
    color: Colors.grey[400],
  ),
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: theme.primaryColor,
    dividerColor: Colors.grey[800],
    buttonTheme: theme.buttonTheme.copyWith(textTheme: ButtonTextTheme.accent),
    iconTheme: theme.iconTheme.copyWith(color: Colors.white70),
  ),
  menuTheme: theme.copyWith(
    textTheme: theme.textTheme
        .apply(displayColor: theme.accentColor, bodyColor: theme.accentColor),
    canvasColor: theme.primaryColor,
    iconTheme: theme.iconTheme.copyWith(
      color: theme.accentColor.withOpacity(0.87),
    ),
  ),
  tabBarHeight: 48,
  primaryButton: ({label, onPressed}) => RaisedButton(
    color: theme.accentColor,
    textTheme: ButtonTextTheme.normal,
    onPressed: onPressed,
    child: Text(label),
  ),
  logo: Logo(
    assetPath: 'assets/party.san/logo.png',
    width: 111,
    height: 56,
  ),
  logoMenu: Logo(
    assetPath: 'assets/party.san/logo_menu.png',
    width: 304,
    height: 152,
  ),
);
