import '../../../features/branch_activation.dart';

/// Abstract repository for the branch activation.
abstract class BranchActivationRepositoryInterface {
  /// Checks if the provided branch activation code was already submitted by
  /// the bank on the console.
  ///
  /// If the first success response returns that the otp is needed, you can
  /// retry this by passing the otpValue and the user token returned in the
  /// first response.
  ///
  /// The [useOTP] parameter is used for indicating if the branch activation
  /// feature should return a second factor method when the bank has submitted
  /// the code.
  Future<BranchActivationResponse?> checkBranchActivationCode({
    required String code,
    String? otpValue,
    String? token,
    bool useOtp = true,
    bool throwAllErrors = true,
  });
}
