import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/otp.dart';
import 'package:mocktail/mocktail.dart';

class MockSecondFactorRepository extends Mock
    implements SecondFactorRepositoryInterface {}

late MockSecondFactorRepository _repository;
late VerifyConsoleUserOTPUseCase _useCase;

final _successId = 1;
final _failureId = 2;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockSecondFactorRepository();
    _useCase = VerifyConsoleUserOTPUseCase(
      repository: _repository,
    );

    when(
      () => _repository.verifyConsoleUserOTP(
        otpId: _successId,
        deviceId: any(named: 'deviceId'),
        value: any(named: 'value'),
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.verifyConsoleUserOTP(
        otpId: _failureId,
        deviceId: any(named: 'deviceId'),
        value: any(named: 'value'),
      ),
    ).thenAnswer(
      (_) async => false,
    );
  });

  test('Should return true', () async {
    final result = await _useCase(
      otpId: _successId,
      deviceId: 100,
      value: '100',
    );

    expect(result, true);

    verify(
      () => _repository.verifyConsoleUserOTP(
        otpId: _successId,
        deviceId: any(named: 'deviceId'),
        value: any(named: 'value'),
      ),
    ).called(1);
  });

  test('Should return false', () async {
    final result = await _useCase(
      otpId: _failureId,
      deviceId: 100,
      value: '100',
    );

    expect(result, false);

    verify(
      () => _repository.verifyConsoleUserOTP(
        otpId: _failureId,
        deviceId: any(named: 'deviceId'),
        value: any(named: 'value'),
      ),
    ).called(1);
  });
}
