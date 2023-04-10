import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data_layer/interfaces.dart';
import '../../../../../presentation_layer/resources.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that manages [Locale] selected by the user.
class LocalizationCubit extends Cubit<LocalizationState> {
  /// Storage used for loading and saving user [Locale].
  final GenericStorage _storage;

  /// Creates [LocalizationCubit].
  LocalizationCubit({
    required GenericStorage storage,
    String? defaultLocaleName,
  })  : _storage = storage,
        super(
          LocalizationState(
            locale: Locale(defaultLocaleName ?? Platform.localeName),
          ),
        );

  /// Loads [Locale] selected by the user from storage.
  Future<void> loadSavedLocale() async {
    emit(
      state.copyWith(
        busy: true,
        error: LocalizationError.none,
      ),
    );

    try {
      final savedLanguageCode = await _storage.getString(
        key: StorageKeys.userSelectedLanguageCode,
      );

      emit(
        state.copyWith(
          locale: savedLanguageCode != null ? Locale(savedLanguageCode) : null,
          busy: false,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: LocalizationError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Sets new [Locale] selected by the user and saves it in storage.
  Future<void> setLocale(Locale locale) async {
    emit(
      state.copyWith(
        busy: true,
        error: LocalizationError.none,
      ),
    );

    try {
      await _storage.setString(
        key: StorageKeys.userSelectedLanguageCode,
        value: locale.languageCode,
      );

      emit(
        state.copyWith(
          locale: locale,
          busy: false,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: LocalizationError.generic,
        ),
      );

      rethrow;
    }
  }
}
