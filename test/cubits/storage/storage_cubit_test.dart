import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/interfaces.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:layer_sdk/presentation_layer/resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGenericStorage extends Mock implements GenericStorage {}

class MockLoadAuthenticationSettingsUseCase extends Mock
    implements LoadAuthenticationSettingsUseCase {}

class MockLoadBrightnessUseCase extends Mock implements LoadBrightnessUseCase {}

class MockLoadLastLoggedUserUseCase extends Mock
    implements LoadLastLoggedUserUseCase {}

class MockLoadOcraSecretKeyUseCase extends Mock
    implements LoadOcraSecretKeyUseCase {}

class MockRemoveUserUseCase extends Mock implements RemoveUserUseCase {}

class MockSaveAuthenticationSettingUseCase extends Mock
    implements SaveAuthenticationSettingUseCase {}

class MockSaveOcraSecretKeyUseCase extends Mock
    implements SaveOcraSecretKeyUseCase {}

class MockSaveUserUseCase extends Mock implements SaveUserUseCase {}

class MockSetBrightnessUseCase extends Mock implements SetBrightnessUseCase {}

class MockToggleBiometricsUseCase extends Mock
    implements ToggleBiometricsUseCase {}

final _loadAuthenticationSettingsUseCase =
    MockLoadAuthenticationSettingsUseCase();
final _loadBrightnessUseCase = MockLoadBrightnessUseCase();
final _loadLastLoggedUserUseCase = MockLoadLastLoggedUserUseCase();
final _loadOcraSecretKeyUseCase = MockLoadOcraSecretKeyUseCase();
final _removeUserUseCase = MockRemoveUserUseCase();
final _saveAuthenticationSettingUseCase =
    MockSaveAuthenticationSettingUseCase();
final _saveOcraSecretKeyUseCase = MockSaveOcraSecretKeyUseCase();
final _saveUserUseCase = MockSaveUserUseCase();
final _setBrightnessUseCase = MockSetBrightnessUseCase();
final _toggleBiometricsUseCase = MockToggleBiometricsUseCase();

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
final _authenticationTestSetting = AuthenticationSettings(
    domain: _domainTest,
    defaultUsername: _defaultUsername,
    useBiometrics: _useBiometrics);

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

final _mockedBrightnessIndex = 5;
late StorageCubit _successCubit;

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    _successCubit = StorageCubit(
      lastLoggedUserUseCase: _loadLastLoggedUserUseCase,
      loadAuthenticationSettingUseCase: _loadAuthenticationSettingsUseCase,
      loadBrightnessUseCase: _loadBrightnessUseCase,
      loadOcraSecretKeyUseCase: _loadOcraSecretKeyUseCase,
      removeUserUseCase: _removeUserUseCase,
      saveAuthenticationSettingUseCase: _saveAuthenticationSettingUseCase,
      saveOcraSecretKeyUseCase: _saveOcraSecretKeyUseCase,
      saveUserUseCase: _saveUserUseCase,
      setBrightnessUseCase: _setBrightnessUseCase,
      toggleBiometricsUseCase: _toggleBiometricsUseCase,
    );
  });

  blocTest<StorageCubit, StorageState>(
    'Should start on an empty state',
    build: () => _successCubit,
    verify: (c) {
      expect(c.state, StorageState());
    },
  ); // Should start on an empty state

  // group('load data tests', _loadDataTests);
  // group('save data tests', _saveDataTests);
  // group('Biometrics', _biometricsTests);
  group('Application Settings', _applicationSettingsTests);
  // group('OCRA key', _ocraKeyTests);
}

void _loadDataTests() {
  setUp(() {
    when(
      _loadLastLoggedUserUseCase,
    ).thenAnswer((_) async => _savedUsers);

    when(
      _loadAuthenticationSettingsUseCase,
    ).thenAnswer((_) async => _authenticationTestSetting);

    when(
      () => _saveAuthenticationSettingUseCase(
        domain: _domainOther,
      ),
    ).thenAnswer((_) async => AuthenticationSettings(domain: _domainOther));

    when(
      () => _saveAuthenticationSettingUseCase(
        domain: _domainTest,
        useBiometrics: _useBiometrics,
        defaultUsername: '',
      ),
    ).thenAnswer((_) async => AuthenticationSettings(
          domain: _domainFail,
          useBiometrics: _failBiometrics,
          defaultUsername: '',
        ));

    when(
      () => _setBrightnessUseCase(
        themeBrightnessIndex: any(named: 'themeBrightnessIndex'),
      ),
    ).thenAnswer((_) async => true);

    when(
      _loadBrightnessUseCase,
    ).thenAnswer((_) async => _mockedBrightnessIndex);
  });

  blocTest<StorageCubit, StorageState>(
    'Should load last logged user',
    build: () => _successCubit,
    act: (c) => c.loadLastLoggedUser(),
    expect: () => [
      StorageState(busy: true),
      StorageState(currentUser: _user),
    ],
    verify: (c) {
      verify(_loadLastLoggedUserUseCase).called(1);
      verifyZeroInteractions(_savedUsers);
    },
  ); // Should load last logged user

  blocTest<StorageCubit, StorageState>(
    'should load authentication settings',
    build: () => _successCubit,
    act: (c) => c.loadAuthenticationSettings(),
    expect: () => [
      StorageState(busy: true),
      StorageState(authenticationSettings: _defaultSettings),
    ],
    verify: (c) {
      verify(
        _loadAuthenticationSettingsUseCase,
      ).called(1);
    },
  ); // should load authentication settings
}

void _saveDataTests() {
  setUp(() {
    when(
      _loadLastLoggedUserUseCase,
    ).thenAnswer((_) async => _savedUsers);

    when(
      _loadLastLoggedUserUseCase,
    ).thenAnswer((_) async => true);

    when(
      () => _saveAuthenticationSettingUseCase(
        domain: _domainOther,
      ),
    ).thenAnswer((_) async => AuthenticationSettings(domain: _domainOther));

    when(
      () => _saveAuthenticationSettingUseCase(
        domain: _domainFail,
      ),
    ).thenAnswer((_) async => AuthenticationSettings(domain: _domainFail));

    when(
      () => _saveAuthenticationSettingUseCase(
        defaultUsername: '',
      ),
    ).thenAnswer((_) async => AuthenticationSettings(defaultUsername: ''));

    when(
      () => _saveAuthenticationSettingUseCase(
        useBiometrics: _useBiometrics,
      ),
    ).thenAnswer(
        (_) async => AuthenticationSettings(useBiometrics: _useBiometrics));

    when(
      () => _saveAuthenticationSettingUseCase(
        useBiometrics: _failBiometrics,
      ),
    ).thenAnswer(
        (_) async => AuthenticationSettings(useBiometrics: _failBiometrics));

    when(() => _setBrightnessUseCase(
          themeBrightnessIndex: any(named: 'themeBrightnessIndex'),
        )).thenAnswer((_) async => true);
  });

  blocTest<StorageCubit, StorageState>(
    'Should save user',
    build: () => _successCubit,
    act: (c) => c.saveUser(user: _user),
    expect: () => [
      StorageState(
        busy: true,
      ),
      StorageState(
        currentUser: _user,
      ),
    ],
    verify: (c) {
      verify(_loadLastLoggedUserUseCase).called(1);
      verify(() => _saveUserUseCase(
            user: _user,
            savedUsers: _savedUsers,
          )).called(1);
    },
  ); // Should save user

  blocTest<StorageCubit, StorageState>(
    'Should remove user',
    build: () => _successCubit,
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
      verify(_loadLastLoggedUserUseCase).called(1);

      verify(() => _saveUserUseCase(
            user: _user,
            savedUsers: {'users': []},
          )).called(1);
    },
  ); // Should remove user

  blocTest<StorageCubit, StorageState>(
    'should save settings',
    build: () => _successCubit,
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
        () => _saveAuthenticationSettingUseCase(
          defaultUsername: any(named: 'defaultUsername'),
        ),
      );
      verify(
        () => _saveAuthenticationSettingUseCase(
          useBiometrics: _useBiometrics,
        ),
      ).called(1);
    },
  ); // should save settings

  blocTest<StorageCubit, StorageState>(
    'should return old biometrics settings when fails to save it',
    build: () => _successCubit,
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
        () => _saveAuthenticationSettingUseCase(
          defaultUsername: any(named: 'value'),
        ),
      );

      verify(
        () => _saveAuthenticationSettingUseCase(
          useBiometrics: _failBiometrics,
        ),
      ).called(1);
    },
  ); // should return old biometrics settings when fails to save it

  blocTest<StorageCubit, StorageState>(
    'should save domain',
    build: () => _successCubit,
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
        () => _saveAuthenticationSettingUseCase(
          defaultUsername: any(named: 'value'),
        ),
      );

      verify(
        () => _saveAuthenticationSettingUseCase(
          domain: _domainOther,
        ),
      ).called(1);
    },
  ); // should save domain

  blocTest<StorageCubit, StorageState>(
    'should return old domain if could not save',
    build: () => _successCubit,
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
        () => _saveAuthenticationSettingUseCase(
          defaultUsername: any(named: 'value'),
        ),
      );

      verify(
        () => _saveAuthenticationSettingUseCase(
          domain: _domainFail,
        ),
      ).called(1);
    },
  ); // should return old domain if could not save
}

void _biometricsTests() {
  setUp(() {
    when(
      () => _saveAuthenticationSettingUseCase(
        useBiometrics: _useBiometrics,
      ),
    ).thenAnswer(
        (_) async => AuthenticationSettings(useBiometrics: _useBiometrics));

    when(
      () => _saveAuthenticationSettingUseCase(
        useBiometrics: _failBiometrics,
      ),
    ).thenThrow(Exception('Some error'));
  });

  blocTest<StorageCubit, StorageState>(
    'should toggle biometrics',
    build: () => _successCubit,
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
        () => _saveAuthenticationSettingUseCase(
          useBiometrics: _useBiometrics,
        ),
      ).called(1);
    },
  ); // should save settings

  blocTest<StorageCubit, StorageState>(
    'should handle exceptions',
    build: () => _successCubit,
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
        () => _saveAuthenticationSettingUseCase(
          useBiometrics: _failBiometrics,
        ),
      ).called(1);
    },
  ); // should handle exceptions
}

void _applicationSettingsTests() {
  final _savedBrightness = SettingThemeBrightness.dark;
  final _failedBrightness = SettingThemeBrightness.light;

  setUp(() {
    //reset(_preferencesStorageMock);

    when(
      _loadBrightnessUseCase,
    ).thenAnswer((_) async => _savedBrightness.index);

    when(
      () => _setBrightnessUseCase(
        themeBrightnessIndex: _savedBrightness.index,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _setBrightnessUseCase(
        themeBrightnessIndex: _failedBrightness.index,
      ),
    ).thenAnswer((_) async => false);
  });

  blocTest<StorageCubit, StorageState>(
    'should load settings',
    build: () => _successCubit,
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
        _loadBrightnessUseCase,
      ).called(1);
    },
  ); // should load settings

  blocTest<StorageCubit, StorageState>(
    'should set brightness',
    build: () => _successCubit,
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
        () => _setBrightnessUseCase(
          themeBrightnessIndex: _savedBrightness.index,
        ),
      ).called(1);
    },
  ); // should set brightness

  blocTest<StorageCubit, StorageState>(
    'should keep brightness if set brightness fails',
    build: () => _successCubit,
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
        () => _setBrightnessUseCase(
          themeBrightnessIndex: _failedBrightness.index,
        ),
      ).called(1);
    },
  ); // should keep brightness if set brightness fails

  group('Exceptions', () {
    setUp(() {
      // reset(_loadBrightnessUseCase);

      when(
        _loadBrightnessUseCase,
      ).thenThrow(Exception('Some error'));

      when(
        () => _setBrightnessUseCase(
          themeBrightnessIndex: _failedBrightness.index,
        ),
      ).thenThrow(Exception('Set error'));
    });

    blocTest<StorageCubit, StorageState>(
      'should handle exceptions when loading',
      build: () => _successCubit,
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
          _loadBrightnessUseCase,
        ).called(1);
      },
    ); // should handle exceptions when loading

    blocTest<StorageCubit, StorageState>(
      'should handle exceptions',
      build: () => _successCubit,
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
          () => _setBrightnessUseCase(
            themeBrightnessIndex: _failedBrightness.index,
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
    //  reset(_loadOcraSecretKeyUseCase);
    when(
      _loadOcraSecretKeyUseCase,
    ).thenAnswer((_) async => successfulOcraKey);

    when(
      () => _saveOcraSecretKeyUseCase(
        value: successfulOcraKey,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _saveOcraSecretKeyUseCase(
        value: failedOcraKey,
      ),
    ).thenThrow(Exception());
  });

  blocTest<StorageCubit, StorageState>(
    'should load ocra key',
    build: () => _successCubit,
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
        _loadOcraSecretKeyUseCase,
      ).called(1);
    },
  ); // should load ocra key

  blocTest<StorageCubit, StorageState>(
    'should save ocra key',
    build: () => _successCubit,
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
        () => _saveOcraSecretKeyUseCase(
          value: successfulOcraKey,
        ),
      ).called(1);
    },
  ); // should save ocra key

  blocTest<StorageCubit, StorageState>(
    'should handle exceptions when saving ocra key',
    build: () => _successCubit,
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
        () => _saveOcraSecretKeyUseCase(
          value: failedOcraKey,
        ),
      ).called(1);
    },
  ); // should handle exceptions
}
