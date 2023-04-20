import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/errors.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockBiometricStorage extends Mock implements BiometricStorage {}

class MockBiometricStorageFile extends Mock implements BiometricStorageFile {}

late MockBiometricStorage _storage;
late MockBiometricStorageFile _storageFile;
late GetAccessPinWithBiometricsUseCase _useCase;

void main() {
  setUpAll(() {
    registerFallbackValue(PromptInfo.defaultValues);
  });

  setUp(
    () {
      _storage = MockBiometricStorage();
      _storageFile = MockBiometricStorageFile();
      _useCase = GetAccessPinWithBiometricsUseCase(storage: _storage);

      when(
        () => _storage.getStorage(
          any(),
          promptInfo: any(named: 'promptInfo'),
          options: any(named: 'options'),
          forceInit: any(named: 'forceInit'),
        ),
      ).thenAnswer((_) async => _storageFile);
    },
  );

  _readTests();
  _errorHandlingTests();
}

void _readTests() {
  group(
    'Read pin',
    () {
      final value = 'value';

      setUp(() {
        when(() => _storage.canAuthenticate()).thenAnswer(
          (_) async => CanAuthenticateResponse.success,
        );

        when(
          () => _storageFile.read(
            promptInfo: any(named: 'promptInfo'),
          ),
        ).thenAnswer((_) async => value);
      });

      test(
        'Should read data from the storage file',
        () async {
          final result = await _useCase();

          expect(result, value);
          verify(() => _storageFile.read()).called(1);
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
            await _useCase();
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
            await _useCase();
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
            await _useCase();
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
            await _useCase();
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
          final value = 'value';

          when(() => _storage.canAuthenticate()).thenAnswer(
            (_) async => CanAuthenticateResponse.success,
          );
          when(
            () => _storageFile.read(
              promptInfo: any(named: 'promptInfo'),
            ),
          ).thenAnswer((_) async => value);

          var thrown = false;
          try {
            await _useCase();
          } on BiometricsNotAvailableException {
            thrown = true;
          }

          expect(thrown, false);
        },
      );
    },
  );
}
