import '../../../../data_layer/network.dart';
import '../dtos.dart';

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
  Future<void> resendCustomerOTP({
    required int otpId,
    String? token,
  }) {
    return netClient.request(
      netClient.netEndpoints.resendOTP,
      data: {
        'otp_id': otpId,
      },
      method: NetRequestMethods.post,
      authorizationHeader: token,
    );
  }

  /// Requests a new 2FA authentication id for the provided `deviceId`.
  ///
  /// The `deviceID` parameter represents the current device the console user
  /// is trying to login with.
  Future<int?> verifyConsoleUserDeviceLogin({
    required int deviceId,
    String method = 'OTP',
  }) async {
    final data = {
      'device_id': deviceId,
      'second_factor': method,
    };

    final response = await netClient.request(
      netClient.netEndpoints.verifyDeviceLogin,
      data: data,
      method: NetRequestMethods.post,
    );

    return response.success ? response.data['otp_id'] : null;
  }

  /// Verifies the console user OTP `value` for the provided `otpId`
  /// and `deviceId`.
  ///
  /// Returns whether or not the OTP value is correct.
  Future<bool> verifyConsoleUserOTP({
    required int otpId,
    required int deviceId,
    required String value,
  }) async {
    final data = {
      'device_id': deviceId,
      'second_factor': 'OTP',
      'otp_id': otpId,
      'value': value,
    };
    final params = {
      'second_factor_verification': true,
    };

    final response = await netClient.request(
      netClient.netEndpoints.verifyDeviceLogin,
      data: data,
      queryParameters: params,
      method: NetRequestMethods.post,
      throwAllErrors: false,
    );

    return response.success;
  }
}
