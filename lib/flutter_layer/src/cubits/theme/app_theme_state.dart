import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../resources.dart';

/// A state representing [AppTheme] preferred by the user
/// for light and dark modes.
class AppThemeState extends Equatable {
  /// All light themes available to the user to choose from.
  ///
  /// Use a non localized theme name as a key.
  final UnmodifiableMapView<String, AppTheme> availableLightThemes;

  /// All dark themes available to the user to choose from.
  ///
  /// Use a non localized theme name as a key.
  final UnmodifiableMapView<String, AppTheme> availableDarkThemes;

  /// [ThemeData] user selected for light mode.
  final AppTheme selectedLightTheme;

  /// [ThemeData] user selected for dark mode.
  ///
  /// This field is optional, if no value is provided
  /// [selectedLightTheme] will be used instead.
  final AppTheme? selectedDarkTheme;

  /// [ThemeMode] preferred by the user.
  ///
  /// Defaults to [ThemeMode.system].
  final ThemeMode mode;

  /// Creates [AppThemeState].
  AppThemeState({
    required Map<String, AppTheme> availableLightThemes,
    required Map<String, AppTheme> availableDarkThemes,
    required this.selectedLightTheme,
    this.selectedDarkTheme,
    this.mode = ThemeMode.system,
  })  : availableLightThemes = UnmodifiableMapView(availableLightThemes),
        availableDarkThemes = UnmodifiableMapView(availableDarkThemes);

  /// Returns a copy modified by supplied not null parameters.
  AppThemeState copyWith({
    Map<String, AppTheme>? availableLightThemes,
    Map<String, AppTheme>? availableDarkThemes,
    AppTheme? selectedLightTheme,
    AppTheme? selectedDarkTheme,
    ThemeMode? mode,
  }) =>
      AppThemeState(
        availableLightThemes: availableLightThemes ?? this.availableLightThemes,
        availableDarkThemes: availableDarkThemes ?? this.availableDarkThemes,
        selectedLightTheme: selectedLightTheme ?? this.selectedLightTheme,
        selectedDarkTheme: selectedDarkTheme ?? this.selectedDarkTheme,
        mode: mode ?? this.mode,
      );

  @override
  List<Object?> get props => [
        availableLightThemes,
        availableDarkThemes,
        selectedLightTheme,
        selectedDarkTheme,
        mode,
      ];
}
