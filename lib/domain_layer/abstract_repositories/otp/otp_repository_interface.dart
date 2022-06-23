import '../../../data_layer/dtos.dart';
import '../../../data_layer/network.dart';

/// Handles OTP methods.
abstract class OTPRepositoryInterface {
  /// Verifies the OTP using the given token.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<void> verifyCustomerOTP({
    required VerifyOtpDTO dto,
    String? token,
  });

  /// Resends the OTP for the given id.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<NetResponse> resendCustomerOTP({
    required int otpId,
    String? token,
  });
}
