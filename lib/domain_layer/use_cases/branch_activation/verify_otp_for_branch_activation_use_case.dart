import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for verifying the OTP on a branch activation.
class VerifyOTPForBranchActivationUseCase {
  final BranchActivationRepositoryInterface _repository;

  /// Creates a new [VerifyOTPForBranchActivationUseCase].
  const VerifyOTPForBranchActivationUseCase({
    required BranchActivationRepositoryInterface repository,
  }) : _repository = repository;

  /// Verifies the OTP for a branch activation code.
  ///
  /// The [useOTP] parameter is used for indicating if the branch activation
  /// feature should return a second factor method when the bank has submitted
  /// the code.
  Future<BranchActivationResponse?> call({
    required String code,
    required String otpValue,
    bool useOTP = true,
  }) =>
      _repository.checkBranchActivationCode(
        code: code,
        otpValue: otpValue,
        useOtp: useOTP,
      );
}
