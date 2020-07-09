import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    this.theme,
    this.aboutTheme,
    this.aboutIcon,
    this.menuTheme,
    this.menuDrawerDecoration,
    this.tabTextStyle,
    this.tabBarDecoration,
    this.tabBarHeight,
    this.primaryButton,
    this.appBar,
    this.eventListItemHeight,
  });

  final ThemeData theme;
  final ThemeData aboutTheme;
  final IconData aboutIcon;
  final ThemeData menuTheme;
  final BoxDecoration menuDrawerDecoration;
  final TextStyle tabTextStyle;
  final BoxDecoration tabBarDecoration;
  final double tabBarHeight;
  final MaterialButton Function({
    String label,
    VoidCallback onPressed,
  }) primaryButton;
  final AppBar Function(String title) appBar;
  final double eventListItemHeight; // TODO(SF) move to global theme
  // TODO(SF) move to global theme
  Icon get heartIcon => Icon(
        Icons.favorite,
        color: Colors.purple,
      );
  // TODO(SF) make schedule icons in general configurable?
}
