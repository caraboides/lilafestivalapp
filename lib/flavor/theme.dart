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

final ThemeData theme = ThemeData(
  primaryColor: Color(0xFF15928c),
  accentColor: Color(0xFFbafb00),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
  ),
  dividerColor: Colors.grey[800],
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
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final Color menuBackgroundColor = Colors.grey[850];
final Color dividerColor = Colors.grey[800];
final Color menuFontColor = Color(0xFFd6102b);
final Color menuIconColor = menuFontColor.withOpacity(0.87);
final TextStyle appBarTextStyle = theme.textTheme.headline4;

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
  aboutTextTheme: Typography.whiteMountainView,
  aboutBackgroundColor: Colors.grey[850],
  primaryButton: ({label, onPressed}) => FlatButton(
    shape: Border(
      top: BorderSide(color: Colors.black, width: 1),
      left: BorderSide(color: Colors.black, width: 1),
      bottom: BorderSide(color: Colors.black, width: 2),
      right: BorderSide(color: Colors.black, width: 2),
    ),
    color: theme.accentColor,
    onPressed: onPressed,
    child: Text(label),
  ),
  appBar: (title) => AppBar(
    title: Text(
      title,
      style: appBarTextStyle,
    ),
    //elevation: 0,
    shape: Border(
      bottom: BorderSide(color: Colors.black, width: 2),
    ),
  ),
  eventListItemHeight: 70,
  bandNameTextStyle: theme.textTheme.headline5,
  bandDetailTextStyle: TextStyle(
    fontWeight: FontWeight.bold,
  ),
);
