import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for saving ocra secret key.
class SaveOcraSecretKeyUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [SaveOcraSecretKeyUseCase] use case.
  SaveOcraSecretKeyUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns `true` if ocra secret key is saved
  Future<bool> call({required String value}) async {
    return await _secureStorage.setString(
      key: StorageKeys.ocraSecretKey,
      value: value,
    );
  }
}
