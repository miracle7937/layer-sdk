import '../../../../data_layer/network.dart';
import '../../providers.dart';
import '../dtos.dart';

/// Handles OTP methods.
class OTPRepository {
  /// The NetClient to use for the network requests.
  final OTPProvider otpProvider;

  /// Creates a new repository with the supplied [OTPProvider].
  OTPRepository({
    required this.otpProvider,
  });

  /// Verifies the OTP using the given token.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<void> verifyCustomerOTP({
    required VerifyOtpDTO dto,
    String? token,
  }) =>
      otpProvider.verifyCustomerOTP(
        dto: dto,
        token: token,
      );

  /// Resends the OTP for the given id.
  ///
  /// The optional [token] parameter can be provided to be used
  /// as an authorization header for the request.
  Future<NetResponse> resendCustomerOTP({
    required int otpId,
    String? token,
  }) =>
      otpProvider.resendCustomerOTP(
        otpId: otpId,
        token: token,
      );
}
