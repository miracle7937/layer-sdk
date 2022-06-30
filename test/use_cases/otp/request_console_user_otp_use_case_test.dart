import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/otp.dart';
import 'package:mocktail/mocktail.dart';

class MockSecondFactorRepository extends Mock
    implements SecondFactorRepositoryInterface {}

late MockSecondFactorRepository _repository;
late RequestConsoleUserOTPUseCase _useCase;

final _successId = 1;
final _failureId = 2;

final _successResult = 100;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockSecondFactorRepository();
    _useCase = RequestConsoleUserOTPUseCase(
      repository: _repository,
    );

    when(
      () => _repository.verifyConsoleUserDeviceLogin(
        deviceId: _successId,
      ),
    ).thenAnswer(
      (_) async => _successResult,
    );

    when(
      () => _repository.verifyConsoleUserDeviceLogin(
        deviceId: _failureId,
      ),
    ).thenAnswer(
      (_) async => null,
    );
  });

  test('Should return the correct result', () async {
    final result = await _useCase(
      deviceId: _successId,
    );

    expect(result, _successResult);

    verify(
      () => _repository.verifyConsoleUserDeviceLogin(
        deviceId: _successId,
      ),
    ).called(1);
  });

  test('Should return null', () async {
    final result = await _useCase(
      deviceId: _failureId,
    );

    expect(result, null);

    verify(
      () => _repository.verifyConsoleUserDeviceLogin(
        deviceId: _failureId,
      ),
    ).called(1);
  });
}
