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
    required double valueLowBalance,
    required String keyLowBalance,
    String? keyAlerted,
    bool? valueAlertLowBalance,
    required String keyAlertLowBalance,
  }) async =>
      _repository.patchUserPreferences(
        userPreferences: [
          BalanceAlertPreference(
            preferenceKey: keyLowBalance,
            preferenceValue: valueLowBalance,
          ),
          if (keyAlerted != null)
            BalanceAlertPreference(
                preferenceKey: keyAlerted, preferenceValue: false),
          if (valueAlertLowBalance != null)
            BalanceAlertPreference(
                preferenceKey: keyAlertLowBalance,
                preferenceValue: valueAlertLowBalance),
        ],
      );
}
