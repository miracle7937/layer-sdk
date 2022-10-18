import '../../../features/user.dart';
import '../../models.dart';
import '../../models/user/alert_preference.dart';

/// Use case that changes alerts preferences of the user.
class ChangeAlertsSettingsUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [ChangeAlertsSettingsUseCase] instance.
  ChangeAlertsSettingsUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Patches an user preference with different data
  Future<User> call({
    required List<ActivityType> alertsTypes,
  }) async =>
      _repository.patchUserPreference(
        userPreference: AlertPreference(value: alertsTypes),
      );
}
