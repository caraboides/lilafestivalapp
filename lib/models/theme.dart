import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    this.theme,
    this.tabTextStyle,
    this.menuEntryTextStyle,
    this.menuDrawerDecoration,
    this.menuIconColor,
  });

  final ThemeData theme;
  final TextStyle tabTextStyle;
  final TextStyle menuEntryTextStyle;
  final BoxDecoration menuDrawerDecoration;
  final Color menuIconColor;
}
