import '../../dtos.dart';
import '../../errors.dart';
import '../../network.dart';

/// A provider that handles API requests related to [UserDTO].
class UserProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [UserProvider].
  UserProvider({
    required this.netClient,
  });

  /// Returns a user. If [customerID] and [username] is null,
  /// returns the current logged in user.
  ///
  /// Throws an exception if the user is not found.
  Future<UserDTO> getUser({
    String? customerID,
    String? username,
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      forceRefresh: forceRefresh,
      queryParameters: {
        if (customerID != null) 'customer_id': customerID,
        if (username != null) 'username': username,
      },
      throwAllErrors: false,
    );

    if (response.data is List && response.data.length > 0) {
      return UserDTO.fromJson(response.data[0]);
    }

    throw UserNotFoundException();
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
    required UserDTO user,
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

    throw UserNotFoundException();
  }

  /// Patches multiple user preferences with different data
  Future<UserDTO> patchUserPreferences({
    required List<UserPreferenceDTO> userPreferences,
  }) async {
    var json = {};
    for (var prefence in userPreferences) {
      json.addAll(prefence.toJson());
    }

    final response = await netClient.request(
      netClient.netEndpoints.user,
      data: [
        {
          'pref': {
            'keys': json,
          }
        },
      ],
      method: NetRequestMethods.patch,
    );

    if (response.data is List && response.data.length > 0) {
      return UserDTO.fromJson(response.data[0]);
    }

    throw UserNotFoundException();
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

    throw UserNotFoundException();
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

    final data = response.data;

    final effectiveData = data['user'] as Map<String, dynamic>;
    final userId = effectiveData['a_user_id'];

    if (data['device'] != null) {
      effectiveData.addAll(data['device']!);
    }

    /// We are checking the user id and adding again to `effectiveData` cause
    /// `effectiveData.addAll(data['device']!)` is overriding the real user id.
    ///
    /// This is because `data['device']` also have a `a_user_id` param but the
    /// value is null.
    if (effectiveData['a_user_id'] == null) {
      effectiveData['a_user_id'] = userId;
    }

    return UserDTO.fromJson(effectiveData);
  }

  /// Uploads the newly selected image for the customer's profile
  Future patchCustomerImage({required String base64}) async {
    var data = {
      "image": base64,
    };

    final response = await netClient.request(
      netClient.netEndpoints.user,
      data: [
        data,
      ],
      method: NetRequestMethods.patch,
    );

    return response.data;
  }
}
