import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    this.theme,
    this.aboutTheme,
    this.menuTheme,
    this.menuDrawerDecoration,
    this.appBarBorder,
    this.tabBarDecoration,
    this.tabBarHeight,
    this.primaryButton,
    this.logo,
    this.logoMenu,
  });

  final ThemeData theme;
  final ThemeData aboutTheme;
  final ThemeData menuTheme;
  final BoxDecoration menuDrawerDecoration;
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

  // TODO(SF) make schedule icons in general configurable?

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
    this.assetPath,
    this.width,
    this.height,
  });

  final String assetPath;
  final double width;
  final double height;
}
