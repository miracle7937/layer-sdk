import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository that can be used to fetch [User].
class UserRepository implements UserRepositoryInterface {
  final UserProvider _userProvider;

  /// Creates a new repository with the supplied [ExperienceProvider].
  UserRepository({
    required UserProvider userProvider,
  }) : _userProvider = userProvider;

  /// Fetches the [User] needed
  @override
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
  @override
  Future<User> patchUser({
    required User user,
  }) async {
    final userDTO = await _userProvider.patchUser(
      user: user,
    );

    return userDTO.toUser();
  }

  /// Patches an user preference with different data
  @override
  Future<User> patchUserPreference({
    required UserPreference userPreference,
  }) async {
    final userDTO = await _userProvider.patchUserPreference(
      userPreference: userPreference,
    );

    return userDTO.toUser();
  }
  /// Patches an user preference with different data
  @override
  Future<User> patchUserPreferences({
    required List<UserPreference> userPreferences,
  }) async {
    final userDTO = await _userProvider.patchUserPreferences(
      userPreferences: userPreferences,
    );

    return userDTO.toUser();
  }

  ///Gets a [User] from a token
  @override
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

  /// Returns an user from a developer `token` and `developerId`.
  @override
  Future<User> getDeveloperUserFromToken({
    required String token,
    required String developerId,
  }) async {
    final userDTO = await _userProvider.getDeveloperUserFromToken(
      token: token,
      developerId: developerId,
    );

    return userDTO.toUser();
  }

  /// Request the lock of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
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
  @override
  Future<User> setAccessPin({
    required String pin,
    required String token,
  }) async {
    final userDTO = await _userProvider.setAccessPin(
      pin: pin,
      token: token,
    );

    return userDTO.toUser(
      accessPin: pin,
    );
  }

  /// Patches the list of blocked channels for the provided user id.
  ///
  /// Used only by the DBO app.
  @override
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
  @override
  Future<bool> patchUserRoles({
    required String userId,
    required List<String> roles,
  }) async =>
      _userProvider.patchUserRoles(
        userId: userId,
        roles: roles,
      );

  /// Uploads the newly selected image
  @override
  Future patchImage({required String base64}) =>
      _userProvider.patchCustomerImage(
        base64: base64,
      );
}
