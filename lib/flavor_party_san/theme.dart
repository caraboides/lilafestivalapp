import 'package:flutter/material.dart';

import '../models/theme.dart';

const String _displayFontFamily = 'Display Font';
final Color _primaryColor = Colors.grey[850]!;
const Color _secondaryColor = Color(0xFFE9D8B3);
final Color _errorColor = Colors.redAccent.shade700;
final Color _lightDividerColor = Colors.grey.shade800;
final Color _historyBackgroundColor = Colors.grey.shade400;
const Color _cardColor = Color.fromARGB(255, 235, 224, 201);
const double _appBarHeight = 49;

final ThemeData theme = ThemeData(
  textTheme: Typography.blackMountainView.copyWith(
    titleLarge: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 17,
      color: _errorColor,
      height: 1.05,
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
    ),
    titleSmall: const TextStyle(fontWeight: FontWeight.bold),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    backgroundColor: _primaryColor,
    titleTextStyle: const TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 26,
    ),
    toolbarHeight: _appBarHeight,
  ),
  tabBarTheme: const TabBarTheme(
    labelStyle: TextStyle(fontFamily: _displayFontFamily, fontSize: 18),
    unselectedLabelStyle: TextStyle(
      fontFamily: _displayFontFamily,
      fontSize: 18,
    ),
  ),
  cardTheme: const CardTheme(
    margin: EdgeInsets.only(bottom: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
    color: _cardColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: _secondaryColor,
  ),
  expansionTileTheme: const ExpansionTileThemeData(iconColor: _secondaryColor),
  dividerTheme: const DividerThemeData(thickness: 1),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return _secondaryColor;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return _secondaryColor;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return _secondaryColor;
      }
      return null;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return _secondaryColor;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    secondary: _secondaryColor,
    error: _errorColor,
  ).copyWith(surface: Colors.white),
);

final FestivalTheme festivalTheme = FestivalTheme(
  theme: theme,
  aboutTheme: theme.copyWith(
    textTheme: Typography.whiteMountainView,
    scaffoldBackgroundColor: _primaryColor,
    dividerColor: _lightDividerColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _secondaryColor),
    ),
    iconTheme: theme.iconTheme.copyWith(color: Colors.white70),
  ),
  menuTheme: theme.copyWith(
    textTheme: theme.textTheme.apply(
      displayColor: theme.colorScheme.secondary,
      bodyColor: theme.colorScheme.secondary,
    ),
    canvasColor: _primaryColor,
    iconTheme: theme.iconTheme.copyWith(
      color: theme.colorScheme.secondary.withAlpha(222),
    ),
    dividerColor: _lightDividerColor,
  ),
  historyTheme: theme.copyWith(
    canvasColor: _historyBackgroundColor,
    scaffoldBackgroundColor: _historyBackgroundColor,
    colorScheme: theme.colorScheme.copyWith(surface: _historyBackgroundColor),
  ),
  primaryButton:
      ({required label, required onPressed}) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
  logo: const Logo(assetPath: 'assets/logo.png', width: 111, height: 56),
  logoMenu: const Logo(
    assetPath: 'assets/logo_menu.png',
    width: 304,
    height: 152,
  ),
  notificationColor: Colors.black,
  bannerBackgroundColor: _primaryColor,
  bannerTextStyle: TextStyle(
    color: theme.colorScheme.secondary,
    fontFamily: 'Display Font',
    fontSize: 20,
  ),
  shimmerColor: _primaryColor,
);
