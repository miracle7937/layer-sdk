import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to the OTP.
class OTPProvider {
  /// The NetClient to use for the network requests.
  final NetClient netClient;

  /// Creates [OTPProvider].
  OTPProvider({
    required this.netClient,
  });

  /// Verifies the OTP using the given token.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<void> verifyCustomerOTP({
    required VerifyOtpDTO dto,
    String? token,
  }) {
    return netClient.request(
      netClient.netEndpoints.deviceOtp,
      data: dto.toJson(),
      method: NetRequestMethods.post,
      authorizationHeader: token,
    );
  }

  /// Resends the OTP for the given id.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<NetResponse> resendCustomerOTP({
    required int otpId,
    String? token,
  }) =>
      netClient.request(
        netClient.netEndpoints.resendOTP,
        data: {
          'otp_id': otpId,
        },
        method: NetRequestMethods.post,
        authorizationHeader: token,
      );
}
