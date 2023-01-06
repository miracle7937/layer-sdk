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

  /// Returns an user from a developer `token` and `developerId`.
  Future<User> getDeveloperUserFromToken({
    required String token,
    required String developerId,
  });

  /// Request the lock of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestLock({
    required String userId,
    required CustomerType customerType,
  });

  /// Request the unlocking of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestUnlock({
    required String userId,
    required CustomerType customerType,
  });

  /// Request the activation of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestActivate({
    required String userId,
    required CustomerType customerType,
  });

  /// Request the deactivation of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestDeactivate({
    required String userId,
    required CustomerType customerType,
  });

  /// Request the deletion of an agent.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<bool> requestDeleteAgent({
    required User user,
  });

  /// Request the password reset for an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestPasswordReset({
    required String userId,
    required CustomerType customerType,
  });

  /// Request the PIN reset for an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestPINReset({
    required String userId,
    required CustomerType customerType,
  });

  /// Sets the access pin for a new user.
  ///
  /// Returns the user object.
  Future<User> setAccessPin({
    required String pin,
    required String token,
  });

  /// Patches the list of blocked channels for the provided user id.
  ///
  /// Used only by the DBO app.
  Future<bool> patchUserBlockedChannels({
    required String userId,
    required List<String> channels,
  });

  /// Patches the list of roles of a user
  ///
  /// Used only by the DBO app.
  Future<bool> patchUserRoles({
    required String userId,
    required List<String> roles,
  });

  /// Fetches the [User]s for customer with [customerID],
  /// optionally filtering them using [name].
  ///
  /// Use [limit] and [offset] to paginate.
  ///
  /// The order is given by [sortBy] (which defaults to
  /// [UserSort.registered] and [descendingOrder], which defaults to `true`.
  Future<List<User>> getUsers({
    required String customerID,
    bool forceRefresh = false,
    String? name,
    UserSort sortBy = UserSort.registered,
    bool descendingOrder = true,
    int limit = 50,
    int offset = 0,
  });

  /// Patches the newly selected image
  Future patchImage({required String base64});
}
