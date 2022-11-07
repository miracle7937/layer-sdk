import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for loading the state of the loyalty tutorial completion.
class LoadLoyaltyTutorialCompletionUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadLoyaltyTutorialCompletionUseCase] use case.
  LoadLoyaltyTutorialCompletionUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns boolean value whether tutorial completed or not.
  Future<bool> call() async =>
      await _secureStorage.getBool(
        key: StorageKeys.completedLoyaltyTutorial,
      ) ??
      false;
}
