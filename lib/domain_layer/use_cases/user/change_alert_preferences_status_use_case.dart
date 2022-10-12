import '../../../features/user.dart';
import '../../models.dart';
import '../../models/user/alert_preference.dart';

/// Use case that adds / removes a favorite offer from the user preferences
/// of a customer.
class ChangeAlertPreferencesStatusUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [ChangeAlertPreferencesStatusUseCase] instance.
  ChangeAlertPreferencesStatusUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Patches an user preference with different data
  Future<User> call({
    required PrefAlerts prefAlerts,
  }) async =>
      _repository.patchUserPreference(
        userPreference: AlertPreference(value: prefAlerts),
      );
}
