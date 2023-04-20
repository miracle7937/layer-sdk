import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/errors.dart';
import 'package:layer_sdk/domain_layer/use_cases/storage/save_access_pin_for_biometrics_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockBiometricStorage extends Mock implements BiometricStorage {}

class MockBiometricStorageFile extends Mock implements BiometricStorageFile {}

late MockBiometricStorage _storage;
late MockBiometricStorageFile _storageFile;
late SaveAccessPinForBiometricsUseCase _useCase;

void main() {
  setUpAll(() {
    registerFallbackValue(PromptInfo.defaultValues);
  });

  setUp(() {
    _storage = MockBiometricStorage();
    _storageFile = MockBiometricStorageFile();
    _useCase = SaveAccessPinForBiometricsUseCase(storage: _storage);

    when(
      () => _storage.getStorage(
        any(),
        promptInfo: any(named: 'promptInfo'),
        options: any(named: 'options'),
        forceInit: any(named: 'forceInit'),
      ),
    ).thenAnswer((_) async => _storageFile);
  });

  _saveTests();
  _errorHandlingTests();
}

void _saveTests() {
  group(
    'Save pin',
    () {
      setUp(() {
        when(() => _storage.canAuthenticate()).thenAnswer(
          (_) async => CanAuthenticateResponse.success,
        );

        when(
          () => _storageFile.write(
            any(),
            promptInfo: any(named: 'promptInfo'),
          ),
        ).thenAnswer((_) async {});
      });

      test(
        'Should write data to the storage file',
        () async {
          final value = 'value';

          await _useCase(value: value);

          verify(() => _storageFile.write(value)).called(1);
        },
      );
    },
  );
}

void _errorHandlingTests() {
  group(
    'Error handling',
    () {
      test(
        'Should throw `BiometricsNotAvailableException` if the biometrics '
        'hardware is not available on the device',
        () async {
          when(() => _storage.canAuthenticate()).thenAnswer(
            (_) async => CanAuthenticateResponse.errorHwUnavailable,
          );

          var thrown = false;
          try {
            await _useCase(value: 'value');
          } on BiometricsNotAvailableException {
            thrown = true;
          }

          expect(thrown, true);
        },
      );

      test(
        'Should throw `BiometricsNotAvailableException` if the biometrics '
        'hardware is not present on the device',
        () async {
          when(() => _storage.canAuthenticate()).thenAnswer(
            (_) async => CanAuthenticateResponse.errorNoHardware,
          );

          var thrown = false;
          try {
            await _useCase(value: 'value');
          } on BiometricsNotAvailableException {
            thrown = true;
          }

          expect(thrown, true);
        },
      );

      test(
        'Should throw `BiometricsNotAvailableException` if the biometrics '
        'status is not known',
        () async {
          when(() => _storage.canAuthenticate()).thenAnswer(
            (_) async => CanAuthenticateResponse.statusUnknown,
          );

          var thrown = false;
          try {
            await _useCase(value: 'value');
          } on BiometricsNotAvailableException {
            thrown = true;
          }

          expect(thrown, true);
        },
      );

      test(
        'Should throw `BiometricsNotAvailableException` if the biometrics '
        'are not configured on the device',
        () async {
          when(() => _storage.canAuthenticate()).thenAnswer(
            (_) async => CanAuthenticateResponse.errorNoBiometricEnrolled,
          );

          var thrown = false;
          try {
            await _useCase(value: 'value');
          } on BiometricsNotAvailableException {
            thrown = true;
          }

          expect(thrown, true);
        },
      );

      test(
        'Should not throw the `BiometricsNotAvailableException` if the '
        'biometrics can be used on the device',
        () async {
          when(() => _storage.canAuthenticate()).thenAnswer(
            (_) async => CanAuthenticateResponse.success,
          );
          when(
            () => _storageFile.write(
              any(),
              promptInfo: any(named: 'promptInfo'),
            ),
          ).thenAnswer((_) async {});

          var thrown = false;
          try {
            await _useCase(value: 'value');
          } on BiometricsNotAvailableException {
            thrown = true;
          }

          expect(thrown, false);
        },
      );
    },
  );
}
