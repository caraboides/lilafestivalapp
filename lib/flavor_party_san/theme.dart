import 'package:flutter/material.dart';

import '../models/theme.dart';

const String _displayFontFamily = 'Display Font';
final Color _primaryColor = Colors.grey[850];
final Color _errorColor = Colors.redAccent[700];
final Color _lightDividerColor = Colors.grey[800];
final Color _historyBackgroundColor = Colors.grey[400];

final ThemeData theme = ThemeData(
  primaryColor: _primaryColor,
  accentColor: const Color(0xFFD2D522),
  errorColor: _errorColor,
  textTheme: Typography.blackMountainView.copyWith(
    headline6: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 17,
      color: _errorColor,
      height: 1.05,
    ),
    headline4: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 24,
      color: Colors.black,
    ),
    headline3: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 28,
      color: Colors.black,
    ),
    headline2: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 28,
      color: _primaryColor.withOpacity(0.87),
    ),
    subtitle2: const TextStyle(
      // TODO(SF) THEME can be part of global theme
      fontWeight: FontWeight.bold,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    textTheme: Typography.whiteMountainView.copyWith(
      headline6: const TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 26,
      ),
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelStyle: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 18,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 18,
    ),
  ),
  cardTheme: CardTheme(
    margin: const EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 1),
    color: Colors.grey[400],
  ),
  backgroundColor: Colors.white,
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: theme.primaryColor,
    dividerColor: _lightDividerColor,
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
    dividerColor: _lightDividerColor,
  ),
  historyTheme: theme.copyWith(
    canvasColor: _historyBackgroundColor,
    scaffoldBackgroundColor: _historyBackgroundColor,
    backgroundColor: _historyBackgroundColor,
  ),
  primaryButton: ({label, onPressed}) => RaisedButton(
    color: theme.accentColor,
    textTheme: ButtonTextTheme.normal,
    onPressed: onPressed,
    child: Text(label),
  ),
  logo: const Logo(
    assetPath: 'assets/logo.png',
    width: 111,
    height: 56,
  ),
  logoMenu: const Logo(
    assetPath: 'assets/logo_menu.png',
    width: 304,
    height: 152,
  ),
  notificationColor: Colors.black,
  bannerBackgroundColor: theme.primaryColor,
  bannerTextStyle: TextStyle(
    color: theme.accentColor,
    fontFamily: 'Display Font',
    fontSize: 20,
  ),
  shimmerColor: _primaryColor,
);
