import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits.dart';

/// The base class for defining an application theme.
///
/// Every app should have a subclass that will define
/// the colors and text styles it uses.
abstract class AppTheme extends Equatable {
  /// Returns [ThemeData] based on the style defined in this [AppTheme].
  ThemeData toThemeData();

  /// Returns the current [AppTheme].
  ///
  /// Type [T] is used to cast the result to a theme specific to the app.
  static T of<T extends AppTheme>(BuildContext context) {
    final themeState = context.read<AppThemeCubit>().state;
    switch (themeState.mode) {
      case ThemeMode.light:
        return themeState.selectedLightTheme as T;
      case ThemeMode.dark:
        return (themeState.selectedDarkTheme ?? themeState.selectedLightTheme)
            as T;
      case ThemeMode.system:
        final platformBrightness = MediaQuery.of(context).platformBrightness;
        return platformBrightness == Brightness.light
            ? themeState.selectedLightTheme as T
            : (themeState.selectedDarkTheme ?? themeState.selectedLightTheme)
                as T;
      default:
        throw UnsupportedError('ThemeMode ${themeState.mode} is not supported');
    }
  }
}
