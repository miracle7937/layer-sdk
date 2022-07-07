import '../../../data_layer/interfaces/generic_storage.dart';
import '../../models.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for loading last logged user.
class LoadLastLoggedUserUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadLastLoggedUserUseCase] use case.
  LoadLastLoggedUserUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns an device sessions response containing a list of device sessions.
  ///
  /// The [deviceTypes] value is used for getting only the device sessions that
  /// belong to those session type list.
  ///
  /// The [status] value is used for getting only the device sessions that
  /// belong to session status.
  ///
  /// The [sortby] value is used for sorting the sessions that belong to
  /// this. For ex. `last_activity`
  Future<User> call({
    User? user,
    required String customerId,
  }) async{
    
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
