import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../providers.dart';

/// A repository that can be used to handle the 2FA.
class SecondFactorRepository implements SecondFactorRepositoryInterface {
  final OTPProvider _otpProvider;

  /// Creates [RegistrationRepository].
  SecondFactorRepository({
    required OTPProvider otpProvider,
  }) : _otpProvider = otpProvider;

  /// Verifies the given second factor for a customer user.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  @override
  Future<void> verifyCustomerSecondFactor({
    required SecondFactorVerification secondFactor,
    required String token,
  }) async {
    switch (secondFactor.type) {
      case SecondFactorType.otp:
        return _otpProvider.verifyCustomerOTP(
          dto: VerifyOtpDTO(
            otpId: secondFactor.id,
            value: secondFactor.value,
          ),
          token: token,
        );
      default:
        throw UnsupportedError(
          'Second factor of type ${secondFactor.type} is not supported',
        );
    }
  }

  /// Resends the OTP for the given id.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  @override
  Future<void> resendCustomerOTP({
    required int otpId,
    String? token,
  }) {
    return _otpProvider.resendCustomerOTP(
      otpId: otpId,
      token: token,
    );
  }
}
