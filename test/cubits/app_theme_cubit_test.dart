import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/interfaces.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:layer_sdk/presentation_layer/resources.dart';
import 'package:mocktail/mocktail.dart';

class MockGenericStorage extends Mock implements GenericStorage {}

late MockGenericStorage storageMock;

_AppThemeStub lightThemeMock = _AppThemeStub(id: 'light');
_AppThemeStub darkThemeMock = _AppThemeStub(id: 'dark');
_AppThemeStub customLightThemeMock = _AppThemeStub(id: 'customLight');
_AppThemeStub customDarkThemeMock = _AppThemeStub(id: 'customDark');

final Map<String, _AppThemeStub> availableLightThemes = {
  'default': lightThemeMock,
  'custom': customLightThemeMock,
};

final Map<String, _AppThemeStub> availableDarkThemes = {
  'default': darkThemeMock,
  'custom': customDarkThemeMock,
};

final AppThemeState defaultState = AppThemeState(
  availableLightThemes: availableLightThemes,
  availableDarkThemes: availableDarkThemes,
  selectedLightTheme: lightThemeMock,
  selectedDarkTheme: darkThemeMock,
);

void main() {
  setUp(() {
    storageMock = MockGenericStorage();
    when(() => storageMock.getString(
          key: StorageKeys.userSelectedLightTheme,
        )).thenAnswer((_) async => 'custom');
    when(() => storageMock.getString(
          key: StorageKeys.userSelectedDarkTheme,
        )).thenAnswer((_) async => 'custom');
    when(() => storageMock.getString(
          key: StorageKeys.userSelectedThemeMode,
        )).thenAnswer((_) async => ThemeMode.light.toString());
  });

  blocTest<AppThemeCubit, AppThemeState>(
    'Should use supplied default state.',
    build: () => AppThemeCubit(
      defaultState: defaultState,
      storage: storageMock,
    ),
    verify: (c) => expect(c.state, defaultState),
  );

  blocTest<AppThemeCubit, AppThemeState>(
    'Should load selected themes from storage.',
    build: () => AppThemeCubit(
      defaultState: defaultState,
      storage: storageMock,
    ),
    act: (c) => c.loadSelectedThemes(),
    expect: () => [
      AppThemeState(
        availableLightThemes: availableLightThemes,
        availableDarkThemes: availableDarkThemes,
        selectedLightTheme: customLightThemeMock,
        selectedDarkTheme: customDarkThemeMock,
        mode: ThemeMode.light,
      ),
    ],
    verify: (c) {
      verify(() => storageMock.getString(
            key: StorageKeys.userSelectedLightTheme,
          )).called(1);
      verify(() => storageMock.getString(
            key: StorageKeys.userSelectedDarkTheme,
          )).called(1);
      verify(() => storageMock.getString(
            key: StorageKeys.userSelectedThemeMode,
          )).called(1);
      verifyNoMoreInteractions(storageMock);
    },
  );

  blocTest<AppThemeCubit, AppThemeState>(
    'Should change light theme data.',
    build: () => AppThemeCubit(
      defaultState: defaultState,
      storage: storageMock,
    ),
    act: (c) => c.setLightTheme(customLightThemeMock),
    expect: () => [
      AppThemeState(
        availableLightThemes: availableLightThemes,
        availableDarkThemes: availableDarkThemes,
        selectedLightTheme: customLightThemeMock,
        selectedDarkTheme: darkThemeMock,
        mode: ThemeMode.system,
      ),
    ],
    verify: (c) {
      verify(() => storageMock.setString(
            key: StorageKeys.userSelectedLightTheme,
            value: 'custom',
          ));
      verifyNoMoreInteractions(storageMock);
    },
  );

  blocTest<AppThemeCubit, AppThemeState>(
    'Should change dark theme data.',
    build: () => AppThemeCubit(
      defaultState: defaultState,
      storage: storageMock,
    ),
    act: (c) => c.setDarkTheme(customDarkThemeMock),
    expect: () => [
      AppThemeState(
        availableLightThemes: availableLightThemes,
        availableDarkThemes: availableDarkThemes,
        selectedLightTheme: lightThemeMock,
        selectedDarkTheme: customDarkThemeMock,
        mode: ThemeMode.system,
      ),
    ],
    verify: (c) {
      verify(() => storageMock.setString(
            key: StorageKeys.userSelectedDarkTheme,
            value: 'custom',
          ));
      verifyNoMoreInteractions(storageMock);
    },
  );

  blocTest<AppThemeCubit, AppThemeState>(
    'Should change theme mode.',
    build: () => AppThemeCubit(
      defaultState: defaultState,
      storage: storageMock,
    ),
    act: (c) => c.setThemeMode(ThemeMode.dark),
    expect: () => [
      AppThemeState(
        availableLightThemes: availableLightThemes,
        availableDarkThemes: availableDarkThemes,
        selectedLightTheme: lightThemeMock,
        selectedDarkTheme: darkThemeMock,
        mode: ThemeMode.dark,
      ),
    ],
    verify: (c) {
      verify(() => storageMock.setString(
            key: StorageKeys.userSelectedThemeMode,
            value: ThemeMode.dark.toString(),
          ));
      verifyNoMoreInteractions(storageMock);
    },
  );
}

class _AppThemeStub extends AppTheme {
  final String id;

  _AppThemeStub({required this.id});

  @override
  List<Object?> get props => [id];

  @override
  ThemeData toThemeData() {
    return ThemeData.light();
  }
}
