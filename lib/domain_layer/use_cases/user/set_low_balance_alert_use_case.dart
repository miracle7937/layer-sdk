import '../../../features/user.dart';
import '../../../features/user_preferences.dart';

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
    required String keyLowBalance,
    required bool valueAlerted,
    required String keyAlerted,
  }) async =>
      _repository.patchUserPreferences(
        userPreferences: [
          BalanceAlertPreference(
            preferenceKey: keyLowBalance,
            preferenceValue: lowBalanceValue,
          ),
          BalanceAlertPreference(
              preferenceKey: keyAlerted, preferenceValue: valueAlerted)
        ],
      );
}
