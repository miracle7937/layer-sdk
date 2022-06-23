import '../../../data_layer/network/net_response.dart';
import '../../abstract_repositories.dart';

/// Use case for resending an OTP.
class ResendOTPUseCase {
  final OTPRepositoryInterface _repository;

  /// Creates a [ResendOTPUseCase].
  const ResendOTPUseCase({
    required OTPRepositoryInterface repository,
  }) : _repository = repository;

  /// Resends the OTP using the otp id.
  Future<NetResponse> call({
    required int otpId,
  }) =>
      _repository.resendCustomerOTP(
        otpId: otpId,
      );
}
