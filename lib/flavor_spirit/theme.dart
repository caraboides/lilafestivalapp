import 'package:flutter/material.dart';

import '../models/theme.dart';

final List<Shadow> _appBarTextShadows = const [
  Offset(1.0, 1.0),
  Offset(1.0, -1.0),
  Offset(-1.0, 1.0),
  Offset(2.0, 2.0),
  Offset(-1.0, -1.0)
]
    .map((offset) => Shadow(
          blurRadius: 1.0,
          color: Colors.black,
          offset: offset,
        ))
    .toList();
const String _displayFontFamily = 'Display Font';
const Color _menuFontColor = Color(0xFFd6102b);
final Color _darkBackgroundColor = Colors.grey[850];
const BorderSide _border = BorderSide(color: Colors.black, width: 2);
final BorderSide _borderSlim = _border.copyWith(width: 1);
final Color _historyBackgroundColor = Colors.grey[400];
const Color _primaryColor = Color(0xFF15928c);

final ThemeData theme = ThemeData(
  primaryColor: _primaryColor,
  accentColor: const Color(0xFFbafb00),
  errorColor: _menuFontColor,
  textTheme: Typography.blackMountainView.copyWith(
    headline6: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 16,
      color: _primaryColor,
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
      height: 1.1,
    ),
    subtitle2: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    textTheme: Typography.whiteMountainView.copyWith(
      headline6: TextStyle(
        fontFamily: _displayFontFamily,
        fontSize: 26,
        shadows: _appBarTextShadows,
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
  cardTheme: const CardTheme(
    margin: EdgeInsets.zero,
    shape: Border(bottom: _border),
    color: Color(0xFFb3dddd),
  ),
  backgroundColor: Colors.white,
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: _darkBackgroundColor,
    dividerColor: Colors.grey[800],
    buttonTheme: theme.buttonTheme.copyWith(textTheme: ButtonTextTheme.accent),
    iconTheme: theme.iconTheme.copyWith(color: Colors.white70),
  ),
  menuTheme: theme.copyWith(
    textTheme: theme.textTheme
        .apply(displayColor: _menuFontColor, bodyColor: _menuFontColor),
    canvasColor: _darkBackgroundColor,
    iconTheme: theme.iconTheme.copyWith(
      color: _menuFontColor.withOpacity(0.87),
    ),
    accentColor: _menuFontColor,
    dividerColor: _menuFontColor,
  ),
  menuDrawerDecoration: const BoxDecoration(border: Border(right: _border)),
  appBarBorder: const Border(bottom: _border),
  tabBarDecoration: const BoxDecoration(border: Border(bottom: _border)),
  historyTheme: theme.copyWith(
    canvasColor: _historyBackgroundColor,
    scaffoldBackgroundColor: _historyBackgroundColor,
    backgroundColor: _historyBackgroundColor,
  ),
  primaryButton: ({label, onPressed}) => FlatButton(
    shape: Border(
      top: _borderSlim,
      left: _borderSlim,
      bottom: _border,
      right: _border,
    ),
    color: theme.accentColor,
    textTheme: ButtonTextTheme.normal,
    onPressed: onPressed,
    child: Text(label),
  ),
  logo: const Logo(
    assetPath: 'assets/logo.png',
    width: 158,
    height: 40,
  ),
  logoMenu: const Logo(
    assetPath: 'assets/logo_menu.png',
    width: 129,
    height: 152,
  ),
  notificationColor: theme.primaryColor,
  bannerBackgroundColor: _darkBackgroundColor,
  bannerTextStyle: TextStyle(
    color: theme.accentColor,
    fontFamily: 'Display Font',
    fontSize: 20,
  ),
  shimmerColor: Colors.white,
);
