import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    this.theme,
    this.aboutTheme,
    this.aboutIcon,
    this.menuTheme,
    this.menuDrawerDecoration,
    this.weatherTheme,
    this.weatherCardDecoration,
    this.appBarBorder,
    this.tabBarDecoration,
    this.tabBarHeight,
    this.primaryButton,
    this.logo,
    this.logoMenu,
  });

  final ThemeData theme;
  final ThemeData aboutTheme;
  // TODO(SF) make schedule icons in general configurable?
  final IconData aboutIcon;
  final ThemeData menuTheme;
  final BoxDecoration menuDrawerDecoration;
  final ThemeData weatherTheme;
  final BoxDecoration weatherCardDecoration;
  final ShapeBorder appBarBorder;
  final BoxDecoration tabBarDecoration;
  final double tabBarHeight;
  final MaterialButton Function({
    String label,
    VoidCallback onPressed,
  }) primaryButton;
  final Logo logo;
  final Logo logoMenu;

  final double eventListItemHeight = 70;
  final double weatherCardHeight = 40;

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
    this.assetPath,
    this.width,
    this.height,
  });

  final String assetPath;
  final double width;
  final double height;
}
