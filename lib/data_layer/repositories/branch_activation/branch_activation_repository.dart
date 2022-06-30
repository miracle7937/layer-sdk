import '../../../../domain_layer/models.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles branch activation data
class BranchActivationRepository
    implements BranchActivationRepositoryInterface {
  final BranchActivationProvider _provider;

  /// Creates a new repository with the supplied [BranchActivationProvider]
  const BranchActivationRepository(
    BranchActivationProvider provider,
  ) : _provider = provider;

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
  @override
  Future<BranchActivationResponse?> checkBranchActivationCode({
    required String code,
    String? otpValue,
    String? token,
    bool useOtp = true,
    bool throwAllErrors = true,
  }) async {
    final dto = await _provider.checkBranchActivationCode(
      code: code,
      otpValue: otpValue,
      token: token,
      useOTP: useOtp,
      throwAllErrors: throwAllErrors,
    );

    return dto?.toBranchActivationResponse();
  }
}
