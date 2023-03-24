import '../../../data_layer/interfaces.dart';
import '../../../data_layer/mappings.dart';
import '../../../presentation_layer/resources.dart';
import '../../models.dart';

/// Use case for loading last logged user.
class LoadLastLoggedUserUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadLastLoggedUserUseCase] use case.
  LoadLastLoggedUserUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns `savedUsers` from storage using [GenericStorage] .
  Future<User?> call() async {
    User? user;

    final savedUsers = await _secureStorage.getJson(StorageKeys.loggedUsers);
    if (savedUsers != null && savedUsers['users'] != null) {
      final users = savedUsers['users'];

      if (users.isNotEmpty) {
        // TODO: decrypt user fields
        // TODO: check which user was logged in the most recently
        user = UserJsonMapping.fromJson(users[0]);
      }
    }
    return user;
  }
}
