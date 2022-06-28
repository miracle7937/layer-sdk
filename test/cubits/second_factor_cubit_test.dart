import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/otp.dart';
import 'package:mocktail/mocktail.dart';

class MockVerifyConsoleUserOTPUseCase extends Mock
    implements VerifyConsoleUserOTPUseCase {}

class MockRequestConsoleUserOTPUseCase extends Mock
    implements RequestConsoleUserOTPUseCase {}

final _verifyConsoleUserOTPUsecase = MockVerifyConsoleUserOTPUseCase();
final _requestConsoleUserOTPUseCase = MockRequestConsoleUserOTPUseCase();

final _successDeviceId = 1;
final _successOTPId = 100;
final _successOTPValue = '1111';
final _failureDeviceId = 2;
final _failureOTPId = 200;
final _failureOTPValue = '2222';

SecondFactorCubit create({
  int deviceId = 0,
}) =>
    SecondFactorCubit(
      requestConsoleUserOTPUseCase: _requestConsoleUserOTPUseCase,
      verifyConsoleUserOTPUseCase: _verifyConsoleUserOTPUsecase,
      deviceId: deviceId,
    );

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    when(
      () => _requestConsoleUserOTPUseCase(deviceId: _successDeviceId),
    ).thenAnswer(
      (_) async => _successOTPId,
    );

    when(
      () => _requestConsoleUserOTPUseCase(deviceId: _failureDeviceId),
    ).thenThrow(
      Exception(),
    );

    when(
      () => _verifyConsoleUserOTPUsecase(
        deviceId: _successDeviceId,
        otpId: _successOTPId,
        value: _successOTPValue,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _verifyConsoleUserOTPUsecase(
        deviceId: _failureDeviceId,
        otpId: _failureOTPId,
        value: _failureOTPValue,
      ),
    ).thenThrow(
      Exception(),
    );
  });

  blocTest<SecondFactorCubit, SecondFactorState>(
    'Starts with empty state',
    build: () => create(
      deviceId: _successDeviceId,
    ),
    verify: (c) => expect(
      c.state,
      SecondFactorState(
        deviceId: _successDeviceId,
      ),
    ),
  );

  blocTest<SecondFactorCubit, SecondFactorState>(
    'Requests OTP successfully',
    build: () => create(
      deviceId: _successDeviceId,
    ),
    act: (c) => c.requestOTP(),
    expect: () => [
      SecondFactorState(
        deviceId: _successDeviceId,
        busyResendingOTP: true,
      ),
      SecondFactorState(
        deviceId: _successDeviceId,
        busyResendingOTP: false,
        otpId: _successOTPId,
      ),
    ],
  );

  blocTest<SecondFactorCubit, SecondFactorState>(
    'Handles exceptions gracefully when requesting OTP',
    build: () => create(
      deviceId: _failureDeviceId,
    ),
    act: (c) => c.requestOTP(),
    expect: () => [
      SecondFactorState(
        deviceId: _failureDeviceId,
        busyResendingOTP: true,
      ),
      SecondFactorState(
        deviceId: _failureDeviceId,
        busyResendingOTP: false,
        error: SecondFactorErrors.generic,
      ),
    ],
  );

  blocTest<SecondFactorCubit, SecondFactorState>(
    'Verifies OTP successfully',
    build: () => create(
      deviceId: _successDeviceId,
    ),
    seed: () => SecondFactorState(
      deviceId: _successDeviceId,
      otpId: _successOTPId,
    ),
    act: (c) => c.verifyOTP(
      value: _successOTPValue,
    ),
    expect: () => [
      SecondFactorState(
        busy: true,
        deviceId: _successDeviceId,
        otpId: _successOTPId,
      ),
      SecondFactorState(
        deviceId: _successDeviceId,
        busy: false,
        validated: true,
        otpId: _successOTPId,
      ),
    ],
  );

  blocTest<SecondFactorCubit, SecondFactorState>(
    'Handles exception gracefully when verifying OTP',
    build: () => create(
      deviceId: _failureDeviceId,
    ),
    seed: () => SecondFactorState(
      deviceId: _failureDeviceId,
      otpId: _failureOTPId,
    ),
    act: (c) => c.verifyOTP(
      value: _failureOTPValue,
    ),
    expect: () => [
      SecondFactorState(
        busy: true,
        deviceId: _failureDeviceId,
        otpId: _failureOTPId,
      ),
      SecondFactorState(
        deviceId: _failureDeviceId,
        busy: false,
        validated: false,
        otpId: _failureOTPId,
        error: SecondFactorErrors.generic,
      ),
    ],
  );
}
