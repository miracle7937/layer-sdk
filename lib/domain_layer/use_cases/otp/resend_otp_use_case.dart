import '../../../_migration/data_layer/repositories.dart';
import '../../../data_layer/network/net_response.dart';

/// Use case for resending an OTP.
class ResendOTPUseCase {
  /// TODO: Replace this with the abstract repository when available.
  final OTPRepository _repository;

  /// Creates a [ResendOTPUseCase].
  const ResendOTPUseCase({
    required OTPRepository repository,
  }) : _repository = repository;

  /// Resends the OTP using the otp id.
  Future<NetResponse> call({
    required int otpId,
  }) =>
      _repository.resendCustomerOTP(
        otpId: otpId,
      );
}
