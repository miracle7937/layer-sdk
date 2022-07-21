import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for loading ocra secret key.
class LoadOcraSecretKeyUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadOcraSecretKeyUseCase] use case.
  LoadOcraSecretKeyUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns ocra secret key using [GenericStorage]
  Future<String?> call() async {
    return await _secureStorage.getString(
      key: StorageKeys.ocraSecretKey,
    );
  }
}
