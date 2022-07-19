import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for removes user.
class RemoveUserUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [RemoveUserUseCase] use case.
  RemoveUserUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Removes user from loggedUsers in [GenericStorage] using provided value,
  /// `id`.
  Future<void> call({
    required String id,
  }) async {
    final savedUsers = await _secureStorage.getJson(StorageKeys.loggedUsers);

    if (savedUsers != null && savedUsers['users'] != null) {
      final users = savedUsers['users'];

      final filteredUsers = users
          .where(
            (userJson) => userJson['id'] != id,
          )
          .toList();

      await _secureStorage.setJson(
        StorageKeys.loggedUsers,
        <String, dynamic>{
          'users': filteredUsers,
        },
      );
    }
  }
}
