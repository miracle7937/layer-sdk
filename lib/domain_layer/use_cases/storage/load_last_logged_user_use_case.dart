import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for loading last logged user.
class LoadLastLoggedUserUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadLastLoggedUserUseCase] use case.
  LoadLastLoggedUserUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns `savedUsers` from storage using [GenericStorage] .
  Future<Map<String, dynamic>?> call({
    required String customerId,
  }) async {
    final savedUsers = await _secureStorage.getJson(StorageKeys.loggedUsers);
    return savedUsers;
  }
}
