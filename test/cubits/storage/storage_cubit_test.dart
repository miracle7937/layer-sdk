import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/interfaces.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:layer_sdk/presentation_layer/resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGenericStorage extends Mock implements GenericStorage {}

late MockGenericStorage _secureStorageMock;
late MockGenericStorage _preferencesStorageMock;

final _domainTest = 'test.domain.com';
final _domainOther = 'other.layer.com';
final _domainFail = 'failed.domain.com';

final _defaultUsername = 'defaultUsername';
final _useBiometrics = true;
final _failBiometrics = false;

final _defaultSettings = AuthenticationSettings(
  domain: _domainTest,
  defaultUsername: _defaultUsername,
  useBiometrics: _useBiometrics,
);

final _savedUsers = {
  'users': [
    <String, dynamic>{
      'id': 'id',
      'username': 'username',
      'first_name': 'firstName',
      'last_name': 'lastName',
      'status': 'UserStatus.active',
      'accessPin': 'accessPin',
    },
  ],
};
final _user = User(
  id: 'id',
  username: 'username',
  firstName: 'firstName',
  lastName: 'lastName',
  status: UserStatus.active,
  favoriteOffers: [],
  accessPin: 'accessPin',
);

final _mockedRemainingAttempts = 5;

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    _secureStorageMock = MockGenericStorage();
    _preferencesStorageMock = MockGenericStorage();
  });

  blocTest<StorageCubit, StorageState>(
    'Should start on an empty state',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    verify: (c) {
      expect(c.state, StorageState());
    },
  ); // Should start on an empty state

  group('load data tests', _loadDataTests);
  group('save data tests', _saveDataTests);
  group('Biometrics', _biometricsTests);
  group('Application Settings', _applicationSettingsTests);
  group('OCRA key', _ocraKeyTests);
}

void _loadDataTests() {
  setUp(() {
    when(
      () => _secureStorageMock.getJson(StorageKeys.loggedUsers),
    ).thenAnswer((_) async => _savedUsers);

    when(
      () => _preferencesStorageMock.getString(key: StorageKeys.authDomain),
    ).thenAnswer((_) async => _domainTest);

    when(
      () => _preferencesStorageMock.getString(
          key: StorageKeys.authDefaultUsername),
    ).thenAnswer((_) async => _defaultUsername);

    when(
      () => _preferencesStorageMock.getBool(key: StorageKeys.authUseBiometrics),
    ).thenAnswer((_) async => _useBiometrics);

    when(
      () => _preferencesStorageMock.setString(
        key: StorageKeys.authDomain,
        value: _domainOther,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setString(
        key: StorageKeys.authDomain,
        value: _domainFail,
      ),
    ).thenAnswer((_) async => false);

    when(
      () => _preferencesStorageMock.setString(
        key: StorageKeys.authDefaultUsername,
        value: '',
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setBool(
        key: StorageKeys.authUseBiometrics,
        value: _useBiometrics,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setBool(
        key: StorageKeys.authUseBiometrics,
        value: _failBiometrics,
      ),
    ).thenAnswer((_) async => false);

    when(
      () => _secureStorageMock.setInt(
        key: StorageKeys.remainingPinAttempts,
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _secureStorageMock.getInt(
        key: StorageKeys.remainingPinAttempts,
      ),
    ).thenAnswer((_) async => _mockedRemainingAttempts);
  });

  blocTest<StorageCubit, StorageState>(
    'Should load last logged user',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.loadLastLoggedUser(),
    expect: () => [
      StorageState(busy: true),
      StorageState(currentUser: _user),
    ],
    verify: (c) {
      verify(() => _secureStorageMock.getJson(StorageKeys.loggedUsers))
          .called(1);
      verifyZeroInteractions(_preferencesStorageMock);
    },
  ); // Should load last logged user

  blocTest<StorageCubit, StorageState>(
    'should load authentication settings',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.loadAuthenticationSettings(),
    expect: () => [
      StorageState(busy: true),
      StorageState(authenticationSettings: _defaultSettings),
    ],
    verify: (c) {
      verify(
        () => _preferencesStorageMock.getString(key: StorageKeys.authDomain),
      ).called(1);

      verify(
        () => _preferencesStorageMock.getString(
            key: StorageKeys.authDefaultUsername),
      ).called(1);

      verify(
        () =>
            _preferencesStorageMock.getBool(key: StorageKeys.authUseBiometrics),
      ).called(1);
    },
  ); // should load authentication settings
}

void _saveDataTests() {
  setUp(() {
    when(
      () => _secureStorageMock.getJson(StorageKeys.loggedUsers),
    ).thenAnswer((_) async => _savedUsers);

    when(
      () => _secureStorageMock.setJson(StorageKeys.loggedUsers, any()),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setString(
        key: StorageKeys.authDomain,
        value: _domainOther,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setString(
        key: StorageKeys.authDomain,
        value: _domainFail,
      ),
    ).thenAnswer((_) async => false);

    when(
      () => _preferencesStorageMock.setString(
        key: StorageKeys.authDefaultUsername,
        value: '',
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setBool(
        key: StorageKeys.authUseBiometrics,
        value: _useBiometrics,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setBool(
        key: StorageKeys.authUseBiometrics,
        value: _failBiometrics,
      ),
    ).thenAnswer((_) async => false);

    when(() => _preferencesStorageMock.setInt(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async => true);
  });

  blocTest<StorageCubit, StorageState>(
    'Should save user',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.saveUser(_user),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(
        currentUser: _user,
      ),
    ],
    verify: (c) {
      verify(() => _secureStorageMock.getJson(StorageKeys.loggedUsers))
          .called(1);
      verify(() => _secureStorageMock.setJson(
            StorageKeys.loggedUsers,
            _savedUsers,
          )).called(1);
    },
  ); // Should save user

  blocTest<StorageCubit, StorageState>(
    'Should remove user',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.removeUser(_user.id),
    seed: () => StorageState(currentUser: _user),
    expect: () => [
      StorageState(
        busy: true,
        currentUser: _user,
      ),
      StorageState(),
    ],
    verify: (c) {
      verify(() => _secureStorageMock.getJson(StorageKeys.loggedUsers))
          .called(1);
      verify(() => _secureStorageMock.setJson(
            StorageKeys.loggedUsers,
            {'users': []},
          )).called(1);
    },
  ); // Should remove user

  blocTest<StorageCubit, StorageState>(
    'should save settings',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    seed: () => StorageState(authenticationSettings: _defaultSettings),
    act: (c) => c.saveAuthenticationSettings(useBiometrics: _useBiometrics),
    expect: () => [
      StorageState(
        authenticationSettings: _defaultSettings,
        busy: true,
      ),
      StorageState(authenticationSettings: _defaultSettings),
    ],
    verify: (c) {
      verifyNever(
        () => _preferencesStorageMock.setString(
          key: StorageKeys.authDefaultUsername,
          value: any(named: 'value'),
        ),
      );

      verify(
        () => _preferencesStorageMock.setBool(
          key: StorageKeys.authUseBiometrics,
          value: _useBiometrics,
        ),
      ).called(1);
    },
  ); // should save settings

  blocTest<StorageCubit, StorageState>(
    'should return old biometrics settings when fails to save it',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.saveAuthenticationSettings(useBiometrics: _failBiometrics),
    seed: () => StorageState(authenticationSettings: _defaultSettings),
    expect: () => [
      StorageState(
        authenticationSettings: _defaultSettings,
        busy: true,
      ),
      StorageState(authenticationSettings: _defaultSettings),
    ],
    verify: (c) {
      verifyNever(
        () => _preferencesStorageMock.setString(
          key: StorageKeys.authDefaultUsername,
          value: any(named: 'value'),
        ),
      );

      verify(
        () => _preferencesStorageMock.setBool(
          key: StorageKeys.authUseBiometrics,
          value: _failBiometrics,
        ),
      ).called(1);
    },
  ); // should return old biometrics settings when fails to save it

  blocTest<StorageCubit, StorageState>(
    'should save domain',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    seed: () => StorageState(authenticationSettings: _defaultSettings),
    act: (c) => c.saveAuthenticationSettings(domain: _domainOther),
    expect: () => [
      StorageState(
        authenticationSettings: _defaultSettings,
        busy: true,
      ),
      StorageState(
        authenticationSettings: _defaultSettings.copyWith(
          domain: _domainOther,
        ),
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _preferencesStorageMock.setString(
          key: StorageKeys.authDefaultUsername,
          value: any(named: 'value'),
        ),
      );

      verify(
        () => _preferencesStorageMock.setString(
          key: StorageKeys.authDomain,
          value: _domainOther,
        ),
      ).called(1);
    },
  ); // should save domain

  blocTest<StorageCubit, StorageState>(
    'should return old domain if could not save',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    seed: () => StorageState(authenticationSettings: _defaultSettings),
    act: (c) => c.saveAuthenticationSettings(domain: _domainFail),
    expect: () => [
      StorageState(
        authenticationSettings: _defaultSettings,
        busy: true,
      ),
      StorageState(authenticationSettings: _defaultSettings),
    ],
    verify: (c) {
      verifyNever(
        () => _preferencesStorageMock.setString(
          key: StorageKeys.authDefaultUsername,
          value: any(named: 'value'),
        ),
      );

      verify(
        () => _preferencesStorageMock.setString(
          key: StorageKeys.authDomain,
          value: _domainFail,
        ),
      ).called(1);
    },
  ); // should return old domain if could not save
}

void _biometricsTests() {
  setUp(() {
    when(
      () => _preferencesStorageMock.setBool(
        key: StorageKeys.authUseBiometrics,
        value: _useBiometrics,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setBool(
        key: StorageKeys.authUseBiometrics,
        value: _failBiometrics,
      ),
    ).thenThrow(Exception('Some error'));
  });

  blocTest<StorageCubit, StorageState>(
    'should toggle biometrics',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    seed: () => StorageState(
      authenticationSettings: _defaultSettings.copyWith(
        useBiometrics: !_useBiometrics,
      ),
    ),
    act: (c) => c.toggleBiometric(
      isBiometricsActive: _useBiometrics,
    ),
    expect: () => [
      StorageState(
        authenticationSettings: _defaultSettings.copyWith(
          useBiometrics: !_useBiometrics,
        ),
        busy: true,
      ),
      StorageState(
        authenticationSettings: _defaultSettings,
      ),
    ],
    verify: (c) {
      verify(
        () => _preferencesStorageMock.setBool(
          key: StorageKeys.authUseBiometrics,
          value: _useBiometrics,
        ),
      ).called(1);
    },
  ); // should save settings

  blocTest<StorageCubit, StorageState>(
    'should handle exceptions',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    seed: () => StorageState(
      authenticationSettings: _defaultSettings,
    ),
    act: (c) => c.toggleBiometric(
      isBiometricsActive: _failBiometrics,
    ),
    expect: () => [
      StorageState(
        authenticationSettings: _defaultSettings,
        busy: true,
      ),
      StorageState(
        authenticationSettings: _defaultSettings,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _preferencesStorageMock.setBool(
          key: StorageKeys.authUseBiometrics,
          value: _failBiometrics,
        ),
      ).called(1);
    },
  ); // should handle exceptions
}

void _applicationSettingsTests() {
  final _savedBrightness = SettingThemeBrightness.dark;
  final _failedBrightness = SettingThemeBrightness.light;

  setUp(() {
    reset(_preferencesStorageMock);

    when(
      () => _preferencesStorageMock.getInt(
        key: StorageKeys.themeBrightness,
      ),
    ).thenAnswer((_) async => _savedBrightness.index);

    when(
      () => _preferencesStorageMock.setInt(
        key: StorageKeys.themeBrightness,
        value: _savedBrightness.index,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _preferencesStorageMock.setInt(
        key: StorageKeys.themeBrightness,
        value: _failedBrightness.index,
      ),
    ).thenAnswer((_) async => false);
  });

  blocTest<StorageCubit, StorageState>(
    'should load settings',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.loadApplicationSettings(),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(
        applicationSettings: ApplicationSettings(
          brightness: _savedBrightness,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _preferencesStorageMock.getInt(
          key: StorageKeys.themeBrightness,
        ),
      ).called(1);
    },
  ); // should load settings

  blocTest<StorageCubit, StorageState>(
    'should set brightness',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.setThemeBrightness(
      themeBrightness: _savedBrightness,
    ),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(
        applicationSettings: ApplicationSettings(
          brightness: _savedBrightness,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _preferencesStorageMock.setInt(
          key: StorageKeys.themeBrightness,
          value: _savedBrightness.index,
        ),
      ).called(1);
    },
  ); // should set brightness

  blocTest<StorageCubit, StorageState>(
    'should keep brightness if set brightness fails',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.setThemeBrightness(
      themeBrightness: _failedBrightness,
    ),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(),
    ],
    verify: (c) {
      verify(
        () => _preferencesStorageMock.setInt(
          key: StorageKeys.themeBrightness,
          value: _failedBrightness.index,
        ),
      ).called(1);
    },
  ); // should keep brightness if set brightness fails

  group('Exceptions', () {
    setUp(() {
      reset(_preferencesStorageMock);

      when(
        () => _preferencesStorageMock.getInt(
          key: StorageKeys.themeBrightness,
        ),
      ).thenThrow(Exception('Some error'));

      when(
        () => _preferencesStorageMock.setInt(
          key: StorageKeys.themeBrightness,
          value: _failedBrightness.index,
        ),
      ).thenThrow(Exception('Set error'));
    });

    blocTest<StorageCubit, StorageState>(
      'should handle exceptions when loading',
      build: () => StorageCubit(
        secureStorage: _secureStorageMock,
        preferencesStorage: _preferencesStorageMock,
      ),
      act: (c) => c.loadApplicationSettings(),
      expect: () => [
        StorageState(
          busy: true,
        ),
        StorageState(),
      ],
      errors: () => [
        isA<Exception>(),
      ],
      verify: (c) {
        verify(
          () => _preferencesStorageMock.getInt(
            key: StorageKeys.themeBrightness,
          ),
        ).called(1);
      },
    ); // should handle exceptions when loading

    blocTest<StorageCubit, StorageState>(
      'should handle exceptions',
      build: () => StorageCubit(
        secureStorage: _secureStorageMock,
        preferencesStorage: _preferencesStorageMock,
      ),
      act: (c) => c.setThemeBrightness(
        themeBrightness: _failedBrightness,
      ),
      expect: () => [
        StorageState(
          busy: true,
        ),
        StorageState(),
      ],
      errors: () => [
        isA<Exception>(),
      ],
      verify: (c) {
        verify(
          () => _preferencesStorageMock.setInt(
            key: StorageKeys.themeBrightness,
            value: _failedBrightness.index,
          ),
        ).called(1);
      },
    ); // should handle exceptions
  });
}

_ocraKeyTests() {
  final successfulOcraKey = 'successfulOcraKey';
  final failedOcraKey = 'failedOcraKey';

  setUp(() {
    reset(_secureStorageMock);

    when(
      () => _secureStorageMock.getString(
        key: StorageKeys.ocraSecretKey,
      ),
    ).thenAnswer((_) async => successfulOcraKey);

    when(
      () => _secureStorageMock.setString(
        key: StorageKeys.ocraSecretKey,
        value: successfulOcraKey,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _secureStorageMock.setString(
        key: StorageKeys.ocraSecretKey,
        value: failedOcraKey,
      ),
    ).thenThrow(Exception());
  });

  blocTest<StorageCubit, StorageState>(
    'should load ocra key',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.loadOcraSecretKey(),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(
        ocraSecretKey: successfulOcraKey,
      ),
    ],
    verify: (c) {
      verify(
        () => _secureStorageMock.getString(
          key: StorageKeys.ocraSecretKey,
        ),
      ).called(1);
    },
  ); // should load ocra key

  blocTest<StorageCubit, StorageState>(
    'should save ocra key',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.saveOcraSecretKey(successfulOcraKey),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(
        ocraSecretKey: successfulOcraKey,
      ),
    ],
    verify: (c) {
      verify(
        () => _secureStorageMock.setString(
          key: StorageKeys.ocraSecretKey,
          value: successfulOcraKey,
        ),
      ).called(1);
    },
  ); // should save ocra key

  blocTest<StorageCubit, StorageState>(
    'should handle exceptions when saving ocra key',
    build: () => StorageCubit(
      secureStorage: _secureStorageMock,
      preferencesStorage: _preferencesStorageMock,
    ),
    act: (c) => c.saveOcraSecretKey(failedOcraKey),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _secureStorageMock.setString(
          key: StorageKeys.ocraSecretKey,
          value: failedOcraKey,
        ),
      ).called(1);
    },
  ); // should handle exceptions
}
