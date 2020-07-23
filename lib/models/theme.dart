import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    @required this.theme,
    @required this.aboutTheme,
    @required this.menuTheme,
    @required this.historyTheme,
    @required this.primaryButton,
    @required this.notificationColor,
    @required this.bannerBackgroundColor,
    @required this.bannerTextStyle,
    this.menuDrawerDecoration,
    this.appBarBorder,
    this.tabBarDecoration,
    this.logo,
    this.logoMenu,
  });

  final ThemeData theme;
  final ThemeData aboutTheme;
  final ThemeData menuTheme;
  final ThemeData historyTheme;
  final BoxDecoration menuDrawerDecoration;
  final ShapeBorder appBarBorder;
  final BoxDecoration tabBarDecoration;
  final MaterialButton Function({
    @required String label,
    @required VoidCallback onPressed,
  }) primaryButton;
  final Logo logo;
  final Logo logoMenu;
  final Color notificationColor;
  final Color bannerBackgroundColor;
  final TextStyle bannerTextStyle;

  final double eventListItemHeight = 70;
  final double weatherCardHeight = 40;
  final double tabBarHeight = 48;

  // TODO(SF) THEME make schedule icons in general configurable?

  IconData get aboutIcon => Icons.star;

  Icon get heartIcon => Icon(
        Icons.favorite,
        color: Colors.purple,
      );

  AppBar appBar(String title) => AppBar(
        title: Text(title),
        shape: appBarBorder,
      );
}

class Logo {
  const Logo({
    @required this.assetPath,
    @required this.width,
    @required this.height,
  });

  final String assetPath;
  final double width;
  final double height;
}
