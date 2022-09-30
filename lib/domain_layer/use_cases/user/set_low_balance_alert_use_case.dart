import '../../../features/user.dart';
import '../../models/user/balance_alert_preference.dart';

/// Use case that adds / removes a low balance alert from the user preferences
/// of a customer.
class SetLowBalanceAlertUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [SetLowBalanceAlertUseCase] instance.
  SetLowBalanceAlertUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Patches an user preference with different low balance alerts
  Future<User> call({
    required double lowBalanceValue,
  }) async =>
      _repository.patchUserPreference(
        userPreference: BalanceAlertPreference(value: lowBalanceValue),
      );
}
