import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for saving biometric usage.
class ToggleBiometricsUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [ToggleBiometricsUseCase] use case.
  ToggleBiometricsUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Sets the biometric usage to the provided value
  Future<void> call({
    required bool isBiometricsActive,
  }) async {
    await _secureStorage.setBool(
      key: StorageKeys.authUseBiometrics,
      value: isBiometricsActive,
    );
  }
}
