import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository that can be used to fetch [User].
class UserRepository implements UserRepositoryInterface {
  /// The provider used for interacting with the API.
  final UserProvider userProvider;

  /// Creates a new repository with the supplied [UserProvider].
  UserRepository({
    required this.userProvider,
  });

  /// Fetches the [User] needed
  @override
  Future<User> getUser({
    String? customerID,
    String? username,
    bool forceRefresh = false,
  }) async {
    final userDTO = await userProvider.getUser(
      customerID: customerID,
      username: username,
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
    final userDTO = await userProvider.patchUser(
      user: user.toUserDTO(),
    );

    return userDTO.toUser();
  }

  /// Patches an user preference with different data
  @override
  Future<User> patchUserPreference({
    required UserPreference userPreference,
  }) async {
    final userDTO = await userProvider.patchUserPreferences(
      userPreferences: [userPreference.toUserPreferenceDTO()],
    );

    return userDTO.toUser();
  }

  /// Patches an user preference with different data
  @override
  Future<User> patchUserPreferences({
    required List<UserPreference> userPreferences,
  }) async {
    final userDTO = await userProvider.patchUserPreferences(
      userPreferences:
          userPreferences.map((e) => e.toUserPreferenceDTO()).toList(),
    );

    return userDTO.toUser();
  }

  ///Gets a [User] from a token
  @override
  Future<User> getUserFromToken({
    required String token,
    bool forceRefresh = true,
  }) async {
    final userDTO = await userProvider.getUserFromToken(
      token: token,
      forceRefresh: forceRefresh,
    );

    return userDTO.toUser();
  }

  /// Sets the access pin for a new user.
  ///
  /// Returns the user object.
  @override
  Future<User> setAccessPin({
    required String pin,
    required String token,
  }) async {
    final userDTO = await userProvider.setAccessPin(
      pin: pin,
      token: token,
    );

    return userDTO.toUser(
      accessPin: pin,
    );
  }

  /// Uploads the newly selected image
  @override
  Future patchImage({required String base64}) =>
      userProvider.patchCustomerImage(
        base64: base64,
      );
}
