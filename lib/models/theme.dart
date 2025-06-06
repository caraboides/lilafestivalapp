import 'package:flutter/material.dart';

class FestivalTheme {
  const FestivalTheme({
    required this.theme,
    required this.aboutTheme,
    required this.menuTheme,
    required this.historyTheme,
    required this.primaryButton,
    required this.notificationColor,
    required this.bannerBackgroundColor,
    required this.bannerTextStyle,
    required this.shimmerColor,
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
  final BoxDecoration? menuDrawerDecoration;
  final ShapeBorder? appBarBorder;
  final BoxDecoration? tabBarDecoration;
  final Widget Function({
    required String label,
    required VoidCallback onPressed,
  })
  primaryButton;
  final Logo? logo;
  final Logo? logoMenu;
  final Color notificationColor;
  final Color bannerBackgroundColor;
  final TextStyle bannerTextStyle;
  final Color shimmerColor;

  final double eventListItemHeight = 80;
  final double denseEventListItemHeight = 42;
  final double toggleIconSize = 48;
  final double toggleDenseIconSize = 32;
  final double toggleDenseSplashRadius = 24;
  final double bandListHeaderHeight = 30;
  final double bandListItemMinHeight = 38;
  final double cardBannerHeight = 40;
  final double tabBarHeight = 48;
  final double alphabeticalIndexWidth = 32;
  // TODO(SF): THEME value ok?
  final int minItemCountForAlphabeticalIndex = 10;

  // TODO(SF): THEME make schedule icons in general configurable?

  IconData get aboutIcon => Icons.star;

  Icon get heartIcon => const Icon(Icons.favorite, color: Colors.purple);

  AppBar appBar(String title) =>
      AppBar(title: Text(title), shape: appBarBorder);

  Color get toggleSplashColor => theme.colorScheme.secondary.withAlpha(138);
}

class Logo {
  const Logo({
    required this.assetPath,
    required this.width,
    required this.height,
  });

  final String assetPath;
  final double width;
  final double height;

  Size get size => Size(width, height);

  Image toAsset() => Image.asset(assetPath, height: height, width: width);
}
