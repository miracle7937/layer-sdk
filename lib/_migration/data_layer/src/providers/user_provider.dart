import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../errors.dart';
import '../dtos.dart';
import '../mappings.dart';

/// A provider that handles API requests related to [UserDTO].
class UserProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [UserProvider].
  UserProvider({
    required this.netClient,
  });

  /// Returns an user. If [customerID] is null, returns the current
  /// logged in user.
  ///
  /// Throws an exception if the user is not found.
  Future<UserDTO> getUser({
    String? customerID,
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      forceRefresh: forceRefresh,
      queryParameters: {
        if (customerID != null) 'customer_id': customerID,
      },
      throwAllErrors: false,
    );

    if (response.data is List && response.data.length > 0) {
      return UserDTO.fromJson(response.data[0]);
    }

    throw Exception('User not found');
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

  /// Patches an user with different data
  /// A [User] is needed with the new data to be patched
  ///
  /// Throws an exception if the user is not found.
  Future<UserDTO> patchUser({
    required User user,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      data: [
        user.toJson(),
      ],
      method: NetRequestMethods.patch,
    );

    if (response.data is List && response.data.length > 0) {
      return UserDTO.fromJson(response.data[0]);
    }

    throw Exception('User not found');
  }

  /// Patches an user preference with different data
  Future<UserDTO> patchUserPreference({
    required UserPreference userPreference,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      data: [
        {
          'pref': {
            'keys': userPreference.toJson(),
          }
        },
      ],
      method: NetRequestMethods.patch,
    );

    if (response.data is List && response.data.length > 0) {
      return UserDTO.fromJson(response.data[0]);
    }

    throw Exception('User not found');
  }

  /// Returns an user from a token.
  ///
  /// Throws an exception if the user is not found.
  Future<UserDTO> getUserFromToken({
    required String token,
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      forceRefresh: forceRefresh,
      authorizationHeader: 'Bearer $token',
    );

    if (response.data is List && response.data.length > 0) {
      return UserDTO.fromJson(response.data[0]);
    }

    throw Exception('User not found');
  }

  /// Used by the console (DBO) to request a change to a user.
  ///
  /// This can be a password reset request, a lock user request, etc.
  ///
  /// All these requests have to be approved by another user to take effect.
  Future<UserDTO> requestChange({
    required RequestChangeType requestType,
    required String userId,
    required String customerType,
  }) async {
    assert(
      netClient.netEndpoints is ConsoleEndpoints,
      'Request Change can only be used on the console app (DBO).',
    );

    // Pin reset still uses a different version 1 flow.
    if (requestType == RequestChangeType.pinReset) {
      return _requestPIN(
        userId: userId,
        customerType: customerType,
      );
    }

    final consoleEndpoints = netClient.netEndpoints as ConsoleEndpoints;

    final response = await netClient.request(
      '${consoleEndpoints.requestChange(userId: userId)}'
      '?customer_type=$customerType',
      method: NetRequestMethods.patch,
      data: {
        'request_url': '${consoleEndpoints.internalRequestURL}'
            '/${consoleEndpoints.authEngineCustomer(userId: userId)}'
            '/${requestType.toCommand()}'
            '?customer_type=$customerType',
        'request_method': 'PATCH',
      },
    );

    return UserDTO.fromJson(response.data);
  }

  Future<UserDTO> _requestPIN({
    required String userId,
    required String customerType,
  }) async {
    final consoleEndpoints = netClient.netEndpoints as ConsoleEndpoints;

    final response = await netClient.request(
      '${consoleEndpoints.resetUserPIN}/$userId?customer_type=$customerType',
      method: NetRequestMethods.patch,
      data: {
        'request_url': '${consoleEndpoints.internalRequestURL}'
            '/${consoleEndpoints.authEngineResetPIN(userId: userId)}'
            '?customer_type=$customerType',
        'request_method': 'POST',
      },
    );

    return UserDTO.fromJson(response.data);
  }

  /// Sets the access pin for a new user.
  Future<UserDTO> setAccessPin({
    required String pin,
    required String token,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.accessPin,
      authorizationHeader: token,
      method: NetRequestMethods.post,
      data: {
        'access_pin': pin,
      },
      forceRefresh: true,
    );

    return UserDTO.fromJson(response.data);
  }

  /// Patches the list of blocked channels for the provided user id.
  ///
  /// Used only by the DBO app.
  Future<bool> patchUserBlockedChannels({
    required String userId,
    required List<String> channels,
  }) async {
    final data = {
      'blocked_channels': channels,
      'a_user_id': int.parse(userId),
    };

    final response = await netClient.request(
      netClient.netEndpoints.user,
      data: [
        data,
      ],
      method: NetRequestMethods.patch,
    );

    return response.success;
  }

  /// Patches the list of roles of a user
  ///
  /// Used only by the DBO app.
  Future<bool> patchUserRoles({
    required String userId,
    required List<String> roles,
  }) async {
    final data = {
      'role_id': roles,
      'a_user_id': int.parse(userId),
    };

    final response = await netClient.request(
      netClient.netEndpoints.user,
      data: [
        data,
      ],
      method: NetRequestMethods.patch,
    );

    return response.success;
  }
}

/// The available request change types.
enum RequestChangeType {
  /// Lock user.
  lock,

  /// Unlock user.
  unlock,

  /// Activate user.
  activate,

  /// Deactivate user.
  deactivate,

  /// Reset user password.
  passwordReset,

  /// Reset user transfer PIN.
  pinReset,
}

extension on RequestChangeType {
  String toCommand() {
    switch (this) {
      case RequestChangeType.lock:
        return 'suspend';

      case RequestChangeType.activate:
      case RequestChangeType.unlock: // It calls the same as activate for now.
        return 'activate';

      case RequestChangeType.deactivate:
        return 'deactivate';

      case RequestChangeType.passwordReset:
        return 'password_reset';

      default:
        throw MappingException(from: RequestChangeType, to: String);
    }
  }
}
