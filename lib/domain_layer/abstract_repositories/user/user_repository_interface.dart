import '../../models.dart';

/// An abstract class for the [User] repository
abstract class UserRepositoryInterface {
  /// Fetches the [User] by `customerId`
  Future<User> getUser({
    String? customerID,
    String? username,
    bool forceRefresh = false,
  });

  /// Patches an user with different data
  ///
  /// A [User] is needed with the new data to be patched
  ///
  /// Throws an exception if the user is not found.
  Future<User> patchUser({
    required User user,
  });

  /// Patches an user preference with different data
  Future<User> patchUserPreference({
    required UserPreference userPreference,
  });

  /// Patches multiple user preferences with different data
  Future<User> patchUserPreferences({
    required List<UserPreference> userPreferences,
  });

  ///Gets a [User] from a token
  Future<User> getUserFromToken({
    required String token,
    bool forceRefresh = true,
  });

  /// Sets the access pin for a new user.
  ///
  /// Returns the user object.
  Future<User> setAccessPin({
    required String pin,
    required String token,
  });

  /// Patches the newly selected image
  Future patchImage({required String base64});
}
