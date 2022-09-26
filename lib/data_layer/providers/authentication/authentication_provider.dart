import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/network.dart';
import '../../../domain_layer/models/device_session/device_session.dart';

/// The available error status
enum ForgotPasswordRequestStatus {
  /// No errors
  none,

  /// Invalid user
  invalidUser,

  /// The user has been suspended error
  suspendedUser,

  /// Success
  success,

  /// Network error
  networkError,

  /// Password recover request is prohibited
  notAllowed,
}

/// Handles calls to the backend API
class AuthenticationProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new AuthenticationProvider
  AuthenticationProvider({
    required this.netClient,
  });

  /// Set the token to use for request authentication.
  // ignore: avoid_setters_without_getters
  set token(String? token) => netClient.token = token;

  /// Sends the log in information to the backend
  ///
  /// If the HTTP status code is OK, returns an UserDTO with the user
  /// information. If not, returns null.
  ///
  /// Also, set the token on the NetClient to the one from the user,
  /// or if there's no logged user, clears it.
  Future<UserDTO?> login(
    String username,
    String password,
    String? notificationToken,
  ) async {
    final response = await netClient.request(
      netClient.netEndpoints.login,
      method: NetRequestMethods.post,
      forceRefresh: true,
      throwAllErrors: false,
      data: {
        'username': username,
        'password': password,
        if (notificationToken != null) 'notification_token': notificationToken,
      },
    );

    final dto = response.data != null ? UserDTO.fromJson(response.data) : null;

    final allowedCodes = [
      LoginCodeDTO.loginStatusSuspended,
      LoginCodeDTO.forceChangePassword,
      LoginCodeDTO.passwordExpired,
      LoginCodeDTO.calendarClosed,
    ];

    if (response.success || allowedCodes.contains(dto?.code)) {
      if (response.success && dto?.token != null) netClient.token = dto!.token!;

      return dto;
    }

    netClient.clearToken();
    return null;
  }

  /// Logs the user out by clearing the cache and clearing the token
  /// on the NetClient.
  Future<bool> logout({int? deviceId}) async {
    if (deviceId != null) {
      await netClient.request(
        netClient.netEndpoints.device,
        method: NetRequestMethods.patch,
        forceRefresh: true,
        throwAllErrors: false,
        data: [
          {
            'device_id': deviceId,
            'status': 'L',
          }
        ],
      );
    }

    netClient.clearToken();
    return netClient.clearCache();
  }

  /// Sends the Recover Password request to the backend
  Future<ForgotPasswordRequestStatus> recoverPassword(String username) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.forgotPassword}/$username',
      method: NetRequestMethods.post,
      forceRefresh: true,
      throwAllErrors: false,
    );

    if (response.success) {
      return ForgotPasswordRequestStatus.success;
    }

    if (response.data['details'] == 'invalid user') {
      return ForgotPasswordRequestStatus.invalidUser;
    }

    if (response.data['code'] == 'prohibited_reset_password') {
      return ForgotPasswordRequestStatus.notAllowed;
    }

    return ForgotPasswordRequestStatus.networkError;
  }

  /// Sends the Recover Password request to the backend
  Future<bool> resetPassword(
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    final response = await netClient.request(
      netClient.netEndpoints.resetPassword,
      method: NetRequestMethods.patch,
      data: {
        "confirm_password": newPassword,
        "initial_step": false,
        "new_password": newPassword,
        "old_password": oldPassword,
        "type": "R",
        "username": username
      },
      forceRefresh: true,
      throwAllErrors: false,
    );

    return response.success;
  }

  /// Verifies the provided access PIN.
  ///
  /// Throws if the pin is invalid.
  Future<VerifyPinResponseDTO> verifyAccessPin(
      String pin, DeviceSession deviceInfo) async {
    // TODO: Check what exactly should be provided. This is hardcoded on x-app:
    final key =
        '-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAg'
        'EA10Y8M+4RAl8KcYNWHoPN\nicJh0gjVFFtM7EVnstMVyMUOIY+qtWwGFJOl8eafurz21R'
        '2G85afKvG9Y2fz3eiI\np+8up9tYpZ9Tg+niB6xZMZDMGVR344/MNsvEUHQZ7e7AqcaR6V'
        'y6NQDl6u9OWuBs\nBNY9LaT8ztYhjZN4FWeDSFCFJy1E9brYCkC3Aadbo42EwF8vaR8Bxs'
        'i4m2b6RGcH\n9nGuML2VrWDe2IkYJ0EkEUS5JYpg+zoqOuvfTM5iU0B7Ex1FWD3hZlWha+'
        'JHMe7c\n0GOrEz9VZnmNCsSCY3qIRQ2vvDD14+DiY7AYRu01NTjB4gbplRS+P1Sp7gdKaw'
        'rZ\nrLB9gw6UhPk1gVWMVMrSyf4HsNqybkSeTWx/0M5DNgVOwKCcdA0+n1CspMY+oNsw\n'
        '1C8VrbGRQEbuyZ6mXWGBREpp+epwMBv/B6uyC5OAbO7A7hXRacj+KsuHo11kdRDS\nA3nx'
        '/taiBKK9d+gBpJfNJ+EhP7KuvmVXKIlS3OgpdobSqIQ1FE/GagcdVpOGJmjQ\nBo7L6g38'
        'By2O0H2B44mG+1wCC8DL4eaIrHP5/FsoMVzYugka7A34i6w44b13jzu4\n+3BYMK6Clnie'
        'oJTTaql/oJKsxctGuqshTztOLP3mgQHGBTf7hMiPm9mGUIZxsMy3\nlWvv4ZYyBQsTMjyQ'
        'AqeEWnECAwEAAQ==\n-----END PUBLIC KEY-----\n';

    final response = await netClient.request(
      netClient.netEndpoints.checkAccessPin,
      method: NetRequestMethods.post,
      throwAllErrors: false,
      data: {
        'access_pin': pin,
        'key': key,
        if (deviceInfo.model?.isNotEmpty ?? false) 'model': deviceInfo.model,
        if (deviceInfo.carrier?.isNotEmpty ?? false)
          'carrier': deviceInfo.carrier,
        if (deviceInfo.deviceName?.isNotEmpty ?? false)
          'device_name': deviceInfo.deviceName,
        if (deviceInfo.osVersion != null) 'os_version': deviceInfo.osVersion,
        if (deviceInfo.resolution != null)
          'resolution':
              '${deviceInfo.resolution!.width}x${deviceInfo.resolution!.width}',
      },
    );

    return VerifyPinResponseDTO.fromJson(response);
  }

  /// Changes the password using the given data.
  Future<ChangeUserPasswordResponseDTO> changeUsersPassword(
    ChangeUserPasswordDTO data,
  ) async {
    final response = await netClient.request(
      netClient.netEndpoints.changePassword,
      method: NetRequestMethods.patch,
      data: data,
      forceRefresh: true,
      throwAllErrors: false,
    );

    return ChangeUserPasswordResponseDTO.fromJson(response.data);
  }
}
