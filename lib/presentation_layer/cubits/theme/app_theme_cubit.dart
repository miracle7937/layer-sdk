import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/interfaces.dart';
import '../../resources.dart';
import 'app_theme_state.dart';

/// Manages selected [ThemeMode] and [AppTheme] for light and dark modes.
class AppThemeCubit extends Cubit<AppThemeState> {
  /// Storage used for loading and saving selected [ThemeData] and [ThemeMode].
  final GenericStorage storage;

  /// Creates [AppThemeCubit] with a default state.
  AppThemeCubit({
    required AppThemeState defaultState,
    required this.storage,
  }) : super(defaultState);

  /// Loads selected [AppTheme] and [ThemeMode].
  Future<void> loadSelectedThemes() async {
    final lightThemeName = await storage.getString(
      key: StorageKeys.userSelectedLightTheme,
    );
    final darkThemeName = await storage.getString(
      key: StorageKeys.userSelectedDarkTheme,
    );
    final modeName = await storage.getString(
      key: StorageKeys.userSelectedThemeMode,
    );
    emit(state.copyWith(
      selectedLightTheme: state.availableLightThemes[lightThemeName],
      selectedDarkTheme: state.availableDarkThemes[darkThemeName],
      mode: ThemeMode.values.firstWhereOrNull(
        (mode) => mode.toString() == modeName,
      ),
    ));
  }

  /// Sets user preferred light [AppTheme].
  Future<void> setLightTheme(AppTheme theme) async {
    emit(state.copyWith(selectedLightTheme: theme));

    final name = state.availableLightThemes.entries
        .firstWhereOrNull(
          (entry) => entry.value == theme,
        )
        ?.key;

    if (name != null) {
      await storage.setString(
        key: StorageKeys.userSelectedLightTheme,
        value: name,
      );
    }
  }

  /// Sets user preferred dark [AppTheme].
  Future<void> setDarkTheme(AppTheme theme) async {
    emit(state.copyWith(selectedDarkTheme: theme));

    final name = state.availableDarkThemes.entries
        .firstWhereOrNull(
          (entry) => entry.value == theme,
        )
        ?.key;

    if (name != null) {
      await storage.setString(
        key: StorageKeys.userSelectedDarkTheme,
        value: name,
      );
    }
  }

  /// Sets user preferred [ThemeMode].
  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(mode: mode));
    await storage.setString(
      key: StorageKeys.userSelectedThemeMode,
      value: mode.toString(),
    );
  }
}
