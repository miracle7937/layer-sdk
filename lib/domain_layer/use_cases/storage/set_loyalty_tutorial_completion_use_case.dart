import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for saving completion of loyalty tutorial.
class SetLoyaltyTutorialCompletionUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [SetLoyaltyTutorialCompletionUseCase] use case.
  SetLoyaltyTutorialCompletionUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Sets the loyalty tutorial completion with the provided value,
  /// that is true by default.
  Future<bool> call({
    bool completed = true,
  }) =>
      _secureStorage.setBool(
        key: StorageKeys.completedLoyaltyTutorial,
        value: completed,
      );
}
