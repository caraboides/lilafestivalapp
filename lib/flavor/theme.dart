import 'package:flutter/material.dart';

import '../models/theme.dart';

List<Shadow> _createShadows(Color color) => [
      Shadow(
        blurRadius: 1.0,
        color: color,
        offset: Offset(1.0, 1.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: color,
        offset: Offset(1.0, -1.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: color,
        offset: Offset(-1.0, 1.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: color,
        offset: Offset(2.0, 2.0),
      ),
      Shadow(
        blurRadius: 1.0,
        color: color,
        offset: Offset(-1.0, -1.0),
      ),
    ];

final Color _accentColor = Color(0xFFbafb00);

final ThemeData theme = ThemeData(
  primaryColor: Color(0xFF15928c),
  accentColor: _accentColor,
  textTheme: Typography.blackMountainView.copyWith(
    headline5: TextStyle(
      fontFamily: 'No Continue',
      fontSize: 28,
      color: Colors.black,
    ),
    headline4: TextStyle(
      fontFamily: 'No Continue',
      fontSize: 26,
      color: Colors.white,
      shadows: _createShadows(Colors.black),
    ),
    headline6: TextStyle(
      fontFamily: 'No Continue',
      fontSize: 24,
      color: Colors.black,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final Color menuFontColor = Color(0xFFd6102b);
final TextStyle appBarTextStyle = theme.textTheme.headline4;

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  menuTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView
        .apply(displayColor: menuFontColor, bodyColor: menuFontColor),
    canvasColor: Colors.grey[850],
    iconTheme: theme.iconTheme.copyWith(color: menuFontColor.withOpacity(0.87)),
  ),
  menuDrawerDecoration: BoxDecoration(
    border: Border(
      right: BorderSide(width: 2, color: Colors.black),
    ),
  ),
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: Colors.grey[850],
    dividerColor: Colors.grey[800],
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    iconTheme: theme.iconTheme.copyWith(color: Colors.white70),
  ),
  aboutIcon: Icons.star,
  tabTextStyle: TextStyle(
    fontFamily: 'No Continue',
    fontSize: 18,
  ),
  tabBarHeight: 48, // TODO(SF) might change with font
  tabBarDecoration: BoxDecoration(
    border: Border(
      bottom: BorderSide(color: Colors.black, width: 2),
    ),
  ),
  primaryButton: ({label, onPressed}) => FlatButton(
    shape: Border(
      top: BorderSide(color: Colors.black, width: 1),
      left: BorderSide(color: Colors.black, width: 1),
      bottom: BorderSide(color: Colors.black, width: 2),
      right: BorderSide(color: Colors.black, width: 2),
    ),
    color: theme.accentColor,
    textTheme: ButtonTextTheme.normal,
    onPressed: onPressed,
    child: Text(label),
  ),
  appBar: (title) => AppBar(
    title: Text(
      title,
      style: appBarTextStyle,
    ),
    shape: Border(
      bottom: BorderSide(color: Colors.black, width: 2),
    ),
  ),
  eventListItemHeight: 70,
);
