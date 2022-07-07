import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/flutter_layer/flutter_layer.dart';
import 'package:mocktail/mocktail.dart';

class MockGenericStorage extends Mock implements GenericStorage {}

final _storageMock = MockGenericStorage();

final Locale _baseLocale = Locale('en');
final Locale _newLocale = Locale('ar');

final _baseState = LocalizationState(
  locale: Locale(Platform.localeName),
);

void main() {
  EquatableConfig.stringify = true;

  blocTest<LocalizationCubit, LocalizationState>(
    'Should use platform locale by default.',
    build: () => LocalizationCubit(storage: _storageMock),
    verify: (c) => expect(
      c.state,
      _baseState,
    ),
  ); // Should use platform locale by default

  blocTest<LocalizationCubit, LocalizationState>(
    'Should accept default locale.',
    build: () => LocalizationCubit(
      storage: _storageMock,
      defaultLocaleName: _newLocale.languageCode,
    ),
    verify: (c) => expect(
      c.state,
      _baseState.copyWith(locale: _newLocale),
    ),
  ); // Should accept default locale

  group('Success Tests', _successTests);
  group('Error Handling Tests', _errorHandling);
}

void _successTests() {
  setUp(() {
    when(
      () => _storageMock.getString(
        key: StorageKeys.userSelectedLanguageCode,
      ),
    ).thenAnswer(
      (_) async => _baseLocale.languageCode,
    );
    when(
      () => _storageMock.setString(
        key: StorageKeys.userSelectedLanguageCode,
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => true);
  });

  blocTest<LocalizationCubit, LocalizationState>(
    'Should load saved locale.',
    build: () => LocalizationCubit(storage: _storageMock),
    act: (c) => c.loadSavedLocale(),
    expect: () => [
      _baseState.copyWith(busy: true),
      _baseState.copyWith(
        locale: _baseLocale,
      ),
    ],
    verify: (c) {
      verify(
        () => _storageMock.getString(
          key: StorageKeys.userSelectedLanguageCode,
        ),
      ).called(1);

      verifyNoMoreInteractions(_storageMock);
    },
  ); // Should load saved locale

  blocTest<LocalizationCubit, LocalizationState>(
    'Should set the selected locale.',
    build: () => LocalizationCubit(storage: _storageMock),
    act: (c) => c.setLocale(_newLocale),
    expect: () => [
      _baseState.copyWith(busy: true),
      _baseState.copyWith(
        locale: _newLocale,
      ),
    ],
    verify: (c) {
      verify(
        () => _storageMock.setString(
          key: StorageKeys.userSelectedLanguageCode,
          value: _newLocale.languageCode,
        ),
      ).called(1);

      verifyNoMoreInteractions(_storageMock);
    },
  ); // Should set the selected locale
}

void _errorHandling() {
  setUp(() {
    when(
      () => _storageMock.getString(
        key: StorageKeys.userSelectedLanguageCode,
      ),
    ).thenThrow(
      Exception('Error'),
    );

    when(
      () => _storageMock.setString(
        key: StorageKeys.userSelectedLanguageCode,
        value: _newLocale.languageCode,
      ),
    ).thenThrow(
      Exception('Save error'),
    );
  });

  blocTest<LocalizationCubit, LocalizationState>(
    'Should handle errors on load saved locale.',
    build: () => LocalizationCubit(storage: _storageMock),
    act: (c) => c.loadSavedLocale(),
    expect: () => [
      _baseState.copyWith(busy: true),
      _baseState.copyWith(
        error: LocalizationError.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _storageMock.getString(
          key: StorageKeys.userSelectedLanguageCode,
        ),
      ).called(1);

      verifyNoMoreInteractions(_storageMock);
    },
  ); // Should handle errors on load saved locale

  blocTest<LocalizationCubit, LocalizationState>(
    'Should handle errors on set the selected locale.',
    build: () => LocalizationCubit(storage: _storageMock),
    act: (c) => c.setLocale(_newLocale),
    expect: () => [
      _baseState.copyWith(busy: true),
      _baseState.copyWith(
        error: LocalizationError.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _storageMock.setString(
          key: StorageKeys.userSelectedLanguageCode,
          value: _newLocale.languageCode,
        ),
      ).called(1);

      verifyNoMoreInteractions(_storageMock);
    },
  ); // Should handle errors on set the selected locale
}
