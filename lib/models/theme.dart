import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    this.theme,
    this.tabTextStyle,
    this.menuEntryTextStyle,
    this.menuDrawerDecoration,
    this.menuIconColor,
    this.aboutTextTheme,
    this.aboutBackgroundColor,
    this.primaryButton,
    this.appBar,
  });

  final ThemeData theme;
  final TextStyle tabTextStyle;
  final TextStyle menuEntryTextStyle;
  final TextTheme aboutTextTheme;
  final BoxDecoration menuDrawerDecoration;
  final Color menuIconColor;
  final Color aboutBackgroundColor;
  final MaterialButton Function({
    String label,
    VoidCallback onPressed,
  }) primaryButton;
  final AppBar Function(String title) appBar;

  ThemeData get aboutTheme => theme.copyWith(
        textTheme: aboutTextTheme,
      );

  Widget get divider => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Divider(color: theme.dividerColor, height: 1),
      );

  Icon get heartIcon => Icon(
        Icons.favorite,
        color: Colors.purple,
      );

  Icon get starIcon => Icon(
        Icons.star,
        color: Colors.white70,
      );
}
