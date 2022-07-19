import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for saving brightness.
class SetBrightnessUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [SetBrightnessUseCase] use case.
  SetBrightnessUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns `true` if theme brightness setting is saved
  Future<bool> call({required int themeBrightnessIndex}) async {
    return await _secureStorage.setInt(
      key: StorageKeys.themeBrightness,
      value: themeBrightnessIndex,
    );
  }
}
