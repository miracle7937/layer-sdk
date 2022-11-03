import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/providers.dart';
import '../../../../domain_layer/models.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../mappings.dart';

/// Handles authentication data
class AuthenticationRepository implements AuthenticationRepositoryInterface {
  final AuthenticationProvider _provider;

  /// Creates a new repository with the supplied [AuthenticationProvider]
  const AuthenticationRepository(
    AuthenticationProvider provider,
  ) : _provider = provider;

  /// Set the token to use for request authentication.
  // ignore: avoid_setters_without_getters
  set token(String? token) => _provider.token = token;

  /// Logs the user in.
  ///
  /// Returns a [User] or null if couldn't log in.
  @override
  Future<User?> login({
    required String username,
    required String password,
    String? notificationToken,
  }) async {
    final userDTO = await _provider.login(
      username,
      password,
      notificationToken,
    );

    if (userDTO == null) return null;
    if (userDTO.code == LoginCodeDTO.invalidCredentials) return null;

    return userDTO.toUser();
  }

  /// Recovers the user's password
  @override
  Future<ForgotPasswordRequestStatus> recoverPassword({
    required String username,
  }) =>
      _provider.recoverPassword(
        username,
      );

  /// Resets the user's password
  @override
  Future<bool> resetPassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) =>
      _provider.resetPassword(
        username,
        oldPassword,
        newPassword,
      );

  /// Logs the user out.
  ///
  /// Returns true if the cache was cleared.
  @override
  Future<bool> logout({
    int? deviceId,
  }) =>
      _provider.logout(
        deviceId: deviceId,
      );

  /// Returns true if the provided pin is valid.
  @override
  Future<VerifyPinResponse> verifyAccessPin({
    required String pin,
    required DeviceSession deviceInfo,
    String? notificationToken,
    String? userToken,
  }) async {
    final verifyPinResponseDTO = await _provider.verifyAccessPin(
      pin,
      deviceInfo,
      userToken,
      notificationToken,
    );

    return verifyPinResponseDTO.toVerifyPinResponse();
  }

  /// Changes the password of an user.
  @override
  Future<MessageResponse> changePassword({
    int? userId,
    String? username,
    User? user,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final dto = await _provider.changeUsersPassword(
      ChangeUserPasswordDTO(
        type: ChangeUserPasswordDTOType.user,
        userId: userId,
        username: username,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );

    return MessageResponse(
      success: dto.success ?? false,
      message: dto.message ?? '',
    );
  }
}
