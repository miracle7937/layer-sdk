import '../../../../domain_layer/models.dart';

/// A repository that can be used to handle the 2FA.
abstract class SecondFactorRepositoryInterface {
  /// Verifies the given second factor for a customer user.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<void> verifyCustomerSecondFactor({
    required SecondFactorVerification secondFactor,
    required String token,
  });

  /// Resends the OTP for the given id.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<void> resendCustomerOTP({
    required int otpId,
    String? token,
  });
}
