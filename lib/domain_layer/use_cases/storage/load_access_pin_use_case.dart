import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for loading ocra secret key.
class LoadAccessPinUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadAccessPinUseCase] use case.
  LoadAccessPinUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns user access pin using [GenericStorage].
  Future<String?> call() async {
    return await _secureStorage.getString(
      key: StorageKeys.accessPin,
    );
  }
}
