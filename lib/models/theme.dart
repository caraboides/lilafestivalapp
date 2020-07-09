import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    this.theme,
    this.aboutTheme,
    this.aboutIcon,
    this.menuTheme,
    this.menuDrawerDecoration,
    this.appBarBorder,
    this.tabTextStyle,
    this.tabBarDecoration,
    this.tabBarHeight,
    this.primaryButton,
  });

  final ThemeData theme;
  final ThemeData aboutTheme;
  final IconData aboutIcon;
  final ThemeData menuTheme;
  final BoxDecoration menuDrawerDecoration;
  final ShapeBorder appBarBorder;
  final TextStyle tabTextStyle;
  final BoxDecoration tabBarDecoration;
  final double tabBarHeight;
  final MaterialButton Function({
    String label,
    VoidCallback onPressed,
  }) primaryButton;

  final double eventListItemHeight = 70;

  Icon get heartIcon => Icon(
        Icons.favorite,
        color: Colors.purple,
      );

  // TODO(SF) make schedule icons in general configurable?
  AppBar appBar(String title) => AppBar(
        title: Text(title),
        shape: appBarBorder,
      );
}
