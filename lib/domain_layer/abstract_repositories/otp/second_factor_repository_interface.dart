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

  /// Requests a new 2FA authentication id for a console user.
  ///
  /// The `deviceID` parameter represents the current device the console user
  /// is trying to login with.
  Future<int?> verifyConsoleUserDeviceLogin({
    required int deviceId,
    String method = 'OTP',
  });

  /// Verifies the OTP with the provided `value` and `otpId`.
  ///
  /// The `deviceID` parameter represents the current device the console user
  /// is trying to login with.
  ///
  /// Returns whether or not the OTP value is correct.
  Future<bool> verifyConsoleUserOTP({
    required int otpId,
    required int deviceId,
    required String value,
  });
}
