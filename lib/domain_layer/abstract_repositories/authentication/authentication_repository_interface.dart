import '../../../data_layer/providers.dart';
import '../../models.dart';

/// The abstract repository that can be used to handle authentication.
abstract class AuthenticationRepositoryInterface {
  /// Verifies the given credentials for a user.
  ///
  /// The optional [notificationToken] parameter can be used
  /// for push notification.
  Future<User?> login({
    required String username,
    required String password,
    String? notificationToken,
  });

  /// Logs out the user for the given `deviceId`.
  Future<void> logout({
    int? deviceId,
  });

  /// Recovers forgotten password for a user.
  Future<ForgotPasswordRequestStatus> recoverPassword({
    required String username,
  });

  /// Resets the user's password with the provided `username` and `oldPassword`
  /// and changes with `newPassword`
  Future<bool> resetPassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  });

  /// Changes the user's password with the provided `oldPassword`
  /// and changes with `newPassword` if matches the `newPassword`
  /// and `confirmPassword`.
  Future<MessageResponse> changePassword({
    int? userId,
    String? username,
    User? user,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  /// Verifies user access pin.
  Future<VerifyPinResponse> verifyAccessPin({
    required String pin,
    required DeviceSession deviceInfo,
    String? notificationToken,
  });
}
