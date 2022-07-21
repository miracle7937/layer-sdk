import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for loading brightness.
class LoadBrightnessUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadBrightnessUseCase] use case.
  LoadBrightnessUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns theme brightness index from [GenericStorage].
  Future<int?> call() async {
    return await _secureStorage.getInt(
      key: StorageKeys.themeBrightness,
    );
  }
}
