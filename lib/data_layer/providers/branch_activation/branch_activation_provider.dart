import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/network.dart';

/// Handles calls to the backend API related to branch activation.
class BranchActivationProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BranchActivationProvider].
  BranchActivationProvider({
    required this.netClient,
  });

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
  Future<BranchActivationResponseDTO?> checkBranchActivationCode({
    required String code,
    String? otpValue,
    String? token,
    bool useOTP = true,
    bool throwAllErrors = true,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.verifyActivationCode}/$code',
      authorizationHeader: token,
      method: NetRequestMethods.get,
      queryParameters: {
        if (otpValue != null) ...{
          'otp_value': otpValue,
          'second_factor_verification': true,
        },
        if (useOTP) 'second_factor': 'OTP',
      },
      forceRefresh: true,
      throwAllErrors: throwAllErrors,
    );

    return response.statusCode == 404
        ? null
        : BranchActivationResponseDTO.fromJson(response.data);
  }
}
