import 'dart:collection';

import 'package:flutter/material.dart';

import '../resources/app_theme.dart';

/// A class containing all the necessary parameters for theme configuration.
class AppThemeConfiguration {
  /// All light themes available to the user to choose from.
  ///
  /// Use a non localized theme names as keys.
  /// This field is required and should contain at least one value.
  final UnmodifiableMapView<String, AppTheme> availableLightThemes;

  /// All dark themes available to the user to choose from.
  ///
  /// Use a non localized theme name as a key.
  /// This field is optional, but necessary for dark mode support.
  final UnmodifiableMapView<String, AppTheme> availableDarkThemes;

  /// The default [AppTheme] to be used when user has no other
  /// preference saved for light mode.
  ///
  /// This field is required.
  final AppTheme defaultTheme;

  /// The default [AppTheme] to be used when user has no other
  /// preference saved for dark mode.
  ///
  /// This field is optional, if no value is provided
  /// [defaultTheme] will be used.
  final AppTheme? defaultDarkTheme;

  /// The default [ThemeMode] to be used when user has
  /// no other preference saved.
  ///
  /// This field is optional, if no value is provided
  /// [ThemeMode.system] will be used.
  final ThemeMode defaultThemeMode;

  /// Creates the [AppThemeConfiguration] object.
  AppThemeConfiguration({
    required Map<String, AppTheme> availableLightThemes,
    Map<String, AppTheme> availableDarkThemes = const {},
    required this.defaultTheme,
    this.defaultDarkTheme,
    this.defaultThemeMode = ThemeMode.system,
  })  : assert(availableLightThemes.isNotEmpty),
        availableLightThemes = UnmodifiableMapView(availableLightThemes),
        availableDarkThemes = UnmodifiableMapView(availableDarkThemes);
}
