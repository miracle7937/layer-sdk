import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// A repository that can be used to fetch [User].
class UserRepository {
  final UserProvider _userProvider;

  /// Creates a new repository with the supplied [ExperienceProvider].
  UserRepository({
    required UserProvider userProvider,
  }) : _userProvider = userProvider;

  /// Fetches the [User] needed
  Future<User> getUser({
    String? customerID,
    bool forceRefresh = false,
  }) async {
    final userDTO = await _userProvider.getUser(
      customerID: customerID,
      forceRefresh: forceRefresh,
    );

    return userDTO.toUser();
  }

  /// Patches an user with different data
  ///
  /// A [User] is needed with the new data to be patched
  ///
  /// Throws an exception if the user is not found.
  Future<User> patchUser({
    required User user,
  }) async {
    final userDTO = await _userProvider.patchUser(
      user: user,
    );

    return userDTO.toUser();
  }

  /// Patches an user preference with different data
  Future<User> patchUserPreference({
    required UserPreference userPreference,
  }) async {
    final userDTO = await _userProvider.patchUserPreference(
      userPreference: userPreference,
    );

    return userDTO.toUser();
  }

  ///Gets a [User] from a token
  Future<User> getUserFromToken({
    required String token,
    bool forceRefresh = true,
  }) async {
    final userDTO = await _userProvider.getUserFromToken(
      token: token,
      forceRefresh: forceRefresh,
    );

    return userDTO.toUser();
  }

  /// Request the lock of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestLock({
    required String userId,
    required CustomerType customerType,
  }) {
    return _userProvider.requestChange(
      requestType: RequestChangeType.lock,
      userId: userId,
      customerType: customerType.toCustomerDTOType(),
    );
  }

  /// Request the unlocking of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestUnlock({
    required String userId,
    required CustomerType customerType,
  }) {
    return _userProvider.requestChange(
      requestType: RequestChangeType.unlock,
      userId: userId,
      customerType: customerType.toCustomerDTOType(),
    );
  }

  /// Request the activation of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestActivate({
    required String userId,
    required CustomerType customerType,
  }) {
    return _userProvider.requestChange(
      requestType: RequestChangeType.activate,
      userId: userId,
      customerType: customerType.toCustomerDTOType(),
    );
  }

  /// Request the deactivation of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestDeactivate({
    required String userId,
    required CustomerType customerType,
  }) {
    return _userProvider.requestChange(
      requestType: RequestChangeType.deactivate,
      userId: userId,
      customerType: customerType.toCustomerDTOType(),
    );
  }

  /// Request the password reset for an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestPasswordReset({
    required String userId,
    required CustomerType customerType,
  }) {
    return _userProvider.requestChange(
      requestType: RequestChangeType.passwordReset,
      userId: userId,
      customerType: customerType.toCustomerDTOType(),
    );
  }

  /// Request the PIN reset for an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> requestPINReset({
    required String userId,
    required CustomerType customerType,
  }) {
    return _userProvider.requestChange(
      requestType: RequestChangeType.pinReset,
      userId: userId,
      customerType: customerType.toCustomerDTOType(),
    );
  }

  /// Sets the access pin for a new user.
  ///
  /// Returns the user object.
  Future<User> setAccessPin({
    required String pin,
    required String token,
  }) async {
    final userDTO = await _userProvider.setAccessPin(
      pin: pin,
      token: token,
    );

    return userDTO.toUser();
  }

  /// Patches the list of blocked channels for the provided user id.
  ///
  /// Used only by the DBO app.
  Future<bool> patchUserBlockedChannels({
    required String userId,
    required List<String> channels,
  }) async =>
      _userProvider.patchUserBlockedChannels(
        userId: userId,
        channels: channels,
      );

  /// Patches the list of roles of a user
  ///
  /// Used only by the DBO app.
  Future<bool> patchUserRoles({
    required String userId,
    required List<String> roles,
  }) async =>
      _userProvider.patchUserRoles(
        userId: userId,
        roles: roles,
      );
}
