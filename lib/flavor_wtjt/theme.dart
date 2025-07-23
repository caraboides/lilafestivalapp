import 'package:flutter/material.dart';

import '../models/theme.dart';

// color: rgb(255, 153, 0)

// _shuttleHeader CSS
// a {
//   color: #FF9900;
//   font-weight: bold;
//   text-decoration: underline;
// }

const String _displayFontFamily = 'Display Font';
final Color _primaryColor = Colors.grey[850]!;
const Color _secondaryColor = Color(0xFFE4BB8A);
final Color _errorColor = Colors.redAccent.shade700;
const Color _lightDividerColor =  Color(0xFFFF9900);
final Color _historyBackgroundColor = Colors.grey.shade400;
final Color _cardColor = Color.alphaBlend(
  Colors.white.withAlpha(128),
  _secondaryColor,
);
const double _appBarHeight = 49;

final _toggleableColorSelected = WidgetStateProperty.resolveWith<Color?>(
  (Set<WidgetState> states) =>
      states.contains(WidgetState.selected) ? _secondaryColor : null,
);

final _colorScheme = ColorScheme.fromSeed(
  seedColor: _primaryColor,
  secondary: _secondaryColor,
  error: _errorColor,
  surface: Colors.white,
);

final ThemeData theme = ThemeData(
  colorScheme: _colorScheme,
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
    foregroundColor: _colorScheme.onPrimary,
  ),
  tabBarTheme: TabBarThemeData(
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
  cardTheme: CardThemeData(
    margin: const EdgeInsets.only(bottom: 1),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    ),
    color: _cardColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: _secondaryColor,
  ),
  expansionTileTheme: const ExpansionTileThemeData(iconColor: _secondaryColor),
  dividerTheme: const DividerThemeData(thickness: 1),
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
  drawerTheme: DrawerThemeData(backgroundColor: _primaryColor),
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
    iconTheme: theme.iconTheme.copyWith(
      color: theme.colorScheme.secondary.withAlpha(222),
    ),
    dividerColor: _lightDividerColor,
    colorScheme: theme.colorScheme.copyWith(
      onSurface: theme.colorScheme.onPrimary,
    ),
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
