import '../../../_migration/data_layer/src/mappings.dart';
import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';
import '../../models.dart';

/// Use case for loading the list of logged in users.
class LoadLoggedInUsersUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadLoggedInUsersUseCase] use case.
  LoadLoggedInUsersUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns a list of logged in users from storage using [GenericStorage].
  Future<List<User>?> call() async {
    List<User>? loggedInUsers;

    final savedUsers = await _secureStorage.getJson(StorageKeys.loggedUsers);

    if (savedUsers != null && savedUsers['users'] != null) {
      final users = List<Map<String, dynamic>>.from(savedUsers['users']);

      if (users.isNotEmpty) {
        loggedInUsers = users.map(UserJsonMapping.fromJson).toList();
      }
    }

    return loggedInUsers;
  }
}
