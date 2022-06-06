import '../../../../domain_layer/models.dart';
import '../../models.dart';
import '../../providers.dart';
import '../dtos.dart';

/// A repository that can be used to handle the 2FA.
class SecondFactorRepository {
  final OTPProvider _otpProvider;

  /// Creates [RegistrationRepository].
  SecondFactorRepository({
    required OTPProvider otpProvider,
  }) : _otpProvider = otpProvider;

  /// Verifies the given second factor for a customer user.
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
  Future<void> resendCustomerOTP({
    required int otpId,
    String? token,
  }) {
    return _otpProvider.resendCustomerOTP(
      otpId: otpId,
      token: token,
    );
  }

  /// Requests a new 2FA authentication id for a console user.
  ///
  /// The `deviceID` parameter represents the current device the console user
  /// is trying to login with.
  Future<int?> verifyConsoleUserDeviceLogin({
    required int deviceId,
    String method = 'OTP',
  }) =>
      _otpProvider.verifyConsoleUserDeviceLogin(
        deviceId: deviceId,
        method: method,
      );

  /// Verifies the OTP with the provided value.
  ///
  /// Returns whether or not the OTP value is correct.
  Future<bool> verifyConsoleUserOTP({
    required int otpId,
    required int deviceId,
    required String value,
  }) =>
      _otpProvider.verifyConsoleUserOTP(
        otpId: otpId,
        deviceId: deviceId,
        value: value,
      );
}
