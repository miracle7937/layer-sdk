import '../../abstract_repositories.dart';

/// Use case that verifies a console user OTP with the provided value,
/// deviceId and otpId.
class VerifyConsoleUserOTPUseCase {
  final SecondFactorRepositoryInterface _repository;

  /// Creates a new [VerifyConsoleUserOTPUseCase] instance.
  VerifyConsoleUserOTPUseCase({
    required SecondFactorRepositoryInterface repository,
  }) : _repository = repository;

  /// Verifies the OTP with the provided value, deviceId and otpId.
  ///
  /// Returns whether or not the OTP value is correct.
  Future<bool> call({
    required int deviceId,
    required int otpId,
    required String value,
  }) =>
      _repository.verifyConsoleUserOTP(
        otpId: otpId,
        deviceId: deviceId,
        value: value,
      );
}
