import 'package:flutter/material.dart';

import '../models/theme.dart';

final List<Shadow> _appBarTextShadows =
    const [
          Offset(1, 1),
          Offset(1, -1),
          Offset(-1, 1),
          Offset(2, 2),
          Offset(-1, -1),
        ]
        .map(
          (offset) =>
              Shadow(blurRadius: 1, color: Colors.black, offset: offset),
        )
        .toList();
const String _displayFontFamily = 'Display Font';
const Color _menuFontColor = Color(0xFFd6102b);
final Color _darkBackgroundColor = Colors.grey[850]!;
const BorderSide _border = BorderSide(color: Colors.black, width: 2);
final BorderSide _borderSlim = _border.copyWith(width: 1);
final Color _historyBackgroundColor = Colors.grey.shade400;
const Color _primaryColor = Color(0xFF15928c);
const Color _secondaryColor = Color(0xFFbafb00);
const double _primaryButtonHeight = 40;
const double _appBarHeight = 54;

final _toggleableColorSelected = WidgetStateProperty.resolveWith<Color?>(
  (Set<WidgetState> states) =>
      states.contains(WidgetState.selected) ? _secondaryColor : null,
);

final _colorScheme = ColorScheme.fromSeed(
  seedColor: _primaryColor,
  secondary: _secondaryColor,
  error: _menuFontColor,
  surface: Colors.white,
);

final ThemeData theme = ThemeData(
  colorScheme: _colorScheme,
  textTheme: Typography.blackMountainView.copyWith(
    titleLarge: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 16,
      color: _menuFontColor,
    ),
    headlineMedium: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 24,
      color: Colors.black,
    ),
    displaySmall: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 28,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 28,
      color: _primaryColor.withAlpha(138),
      height: 1.1,
    ),
    titleSmall: const TextStyle(fontWeight: FontWeight.bold),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    backgroundColor: _primaryColor,
    titleTextStyle: Typography.whiteMountainView.titleLarge?.copyWith(
      fontFamily: _displayFontFamily,
      fontSize: 26,
      shadows: _appBarTextShadows,
    ),
    toolbarHeight: _appBarHeight,
    foregroundColor: _colorScheme.onPrimary,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 18,
      color: Colors.white,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 18,
      color: Colors.white.withAlpha(138),
    ),
    indicatorSize: TabBarIndicatorSize.tab,
  ),
  cardTheme: const CardTheme(
    margin: EdgeInsets.zero,
    shape: Border(bottom: _border),
    color: Color(0xFFb3dddd),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: _secondaryColor,
  ),
  expansionTileTheme: const ExpansionTileThemeData(iconColor: _menuFontColor),
  checkboxTheme: CheckboxThemeData(fillColor: _toggleableColorSelected),
  radioTheme: RadioThemeData(fillColor: _toggleableColorSelected),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) =>
          states.contains(WidgetState.selected)
              ? _primaryColor
              : _colorScheme.outline,
    ),
    trackColor: _toggleableColorSelected,
  ),
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: _darkBackgroundColor,
    dividerColor: Colors.grey[800],
    buttonTheme: theme.buttonTheme.copyWith(textTheme: ButtonTextTheme.accent),
    iconTheme: theme.iconTheme.copyWith(color: Colors.white70),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _secondaryColor),
    ),
  ),
  menuTheme: theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(onSurface: _menuFontColor),
    dividerColor: _menuFontColor,
  ),
  menuDrawerDecoration: const BoxDecoration(border: Border(right: _border)),
  appBarBorder: const Border(bottom: _border),
  tabBarDecoration: const BoxDecoration(border: Border(bottom: _border)),
  historyTheme: theme.copyWith(
    canvasColor: _historyBackgroundColor,
    scaffoldBackgroundColor: _historyBackgroundColor,
    colorScheme: theme.colorScheme.copyWith(surface: _historyBackgroundColor),
  ),
  primaryButton:
      ({required label, required onPressed}) => Container(
        height: _primaryButtonHeight,
        foregroundDecoration: BoxDecoration(
          border: Border(
            top: _borderSlim,
            left: _borderSlim,
            bottom: _border,
            right: _border,
          ),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
            backgroundColor: theme.colorScheme.secondary,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
  logo: const Logo(assetPath: 'assets/logo.png', width: 158, height: 40),
  logoMenu: const Logo(
    assetPath: 'assets/logo_menu.png',
    width: 129,
    height: 152,
  ),
  notificationColor: theme.primaryColor,
  bannerBackgroundColor: _darkBackgroundColor,
  bannerTextStyle: TextStyle(
    color: theme.colorScheme.secondary,
    fontFamily: 'Display Font',
    fontSize: 20,
  ),
  shimmerColor: Colors.white,
);
