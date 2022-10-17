import '../../../features/user.dart';
import '../../models.dart';

/// Use case that adds/updates a custom user prefs
class SetCustomUserPrefsUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [SetCustomUserPrefsUseCase] instance.
  SetCustomUserPrefsUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Patches an user preference with different low balance alerts
  Future<User> call({
    required String key,
    required dynamic value,
  }) async =>
      _repository.patchUserPreferences(
        userPreferences: [
          CustomUserPreference(
            key: key,
            value: value,
          ),
        ],
      );
}
