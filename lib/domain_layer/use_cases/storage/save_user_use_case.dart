import '../../../data_layer/interfaces.dart';
import '../../../data_layer/mappings.dart';
import '../../../presentation_layer/resources.dart';
import '../../models.dart';

/// Use case for saving user.
class SaveUserUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [SaveUserUseCase] use case.
  SaveUserUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Saves the user to `loggedUsers` using [GenericStorage].
  Future<void> call({
    required User user,
    Map<String, dynamic>? savedUsers,
  }) async {
    var loggedUsers = savedUsers;
    if (loggedUsers == null) {
      loggedUsers = await _secureStorage.getJson(StorageKeys.loggedUsers);

      loggedUsers ??= <String, dynamic>{
        'users': [],
      };

      // TODO: encrypt the user data
      loggedUsers['users']
          .removeWhere((u) => UserJsonMapping.fromJson(u).id == user.id);
      loggedUsers['users'].add(user.toJson());
    }

    await _secureStorage.setJson(
      StorageKeys.loggedUsers,
      loggedUsers,
    );
  }
}
