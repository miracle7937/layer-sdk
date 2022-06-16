import '../../../../data_layer/dtos.dart';
import '../../../../domain_layer/models.dart';
import '../../models.dart';
import '../../providers.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Handles authentication data
class AuthenticationRepository {
  final AuthenticationProvider _provider;
  final UserProvider _userProvider;

  /// Creates a new repository with the supplied [AuthenticationProvider]
  const AuthenticationRepository(
    AuthenticationProvider provider,
    UserProvider userProvider,
  )   : _provider = provider,
        _userProvider = userProvider;

  /// Set the token to use for request authentication.
  // ignore: avoid_setters_without_getters
  set token(String? token) => _provider.token = token;

  /// Logs the user in.
  ///
  /// Returns a [User] or null if couldn't log in.
  Future<User?> login(
    String username,
    String password,
    String? notificationToken,
  ) async {
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
  Future<ForgotPasswordRequestStatus> recoverPassword(String username) =>
      _provider.recoverPassword(username);

  /// Resets the user's password
  Future<bool> resetPassword(
    String username,
    String oldPassword,
    String newPassword,
  ) =>
      _provider.resetPassword(
        username,
        oldPassword,
        newPassword,
      );

  /// Logs the user out.
  ///
  /// Returns true if the cache was cleared.
  Future<bool> logout({int? deviceId}) => _provider.logout(deviceId: deviceId);

  /// Returns true if the provided pin is valid.
  Future<VerifyPinResponse> verifyAccessPin(String pin) async {
    final verifyPinResponseDTO = await _provider.verifyAccessPin(
      pin,
    );

    return verifyPinResponseDTO.toVerifyPinResponse();
  }

  /// Changes the password of an user.
  Future<MessageResponse> changePassword({
    int? userId,
    String? username,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    final dto = await _userProvider.changeUsersPassword(
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
  Future<BranchActivationResponse?> checkBranchActivationCode({
    required String code,
    String? otpValue,
    String? token,
    bool useOtp = true,
    bool throwAllErrors = true,
  }) async {
    final dto = await _provider.checkBranchActivationCode(
      code: code,
      otpValue: otpValue,
      token: token,
      useOTP: useOtp,
      throwAllErrors: throwAllErrors,
    );

    return dto?.toBranchActivationResponse();
  }
}
