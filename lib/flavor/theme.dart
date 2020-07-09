import 'package:flutter/material.dart';

import '../models/theme.dart';

final List<Shadow> _appBarTextShadows = [
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
final String displayFontFamily = 'No Continue';
final Color _menuFontColor = Color(0xFFd6102b);
final Color _darkBackgroundColor = Colors.grey[850];
final BorderSide _border = BorderSide(color: Colors.black, width: 2);
final BorderSide _borderSlim = _border.copyWith(width: 1);

final ThemeData theme = ThemeData(
  primaryColor: Color(0xFF15928c),
  accentColor: Color(0xFFbafb00),
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
      fontWeight: FontWeight.bold,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    textTheme: Typography.whiteMountainView.copyWith(
      headline6: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 26,
        shadows: _appBarTextShadows,
      ),
    ),
  ),
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: _darkBackgroundColor,
    dividerColor: Colors.grey[800],
    buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
    iconTheme: theme.iconTheme.copyWith(color: Colors.white70),
  ),
  aboutIcon: Icons.star,
  menuTheme: theme.copyWith(
    textTheme: theme.textTheme
        .apply(displayColor: _menuFontColor, bodyColor: _menuFontColor),
    canvasColor: _darkBackgroundColor,
    iconTheme: theme.iconTheme.copyWith(
      color: _menuFontColor.withOpacity(0.87),
    ),
  ),
  menuDrawerDecoration: BoxDecoration(border: Border(right: _border)),
  appBarBorder: Border(bottom: _border),
  tabTextStyle: TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 18,
  ),
  tabBarHeight: 48,
  tabBarDecoration: BoxDecoration(border: Border(bottom: _border)),
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
  logo: Logo(
    assetPath: 'assets/logo.png',
    width: 158,
    height: 40,
  ),
  logoMenu: Logo(
    assetPath: 'assets/logo_menu.png',
    width: 304,
    height: 152,
  ),
);
