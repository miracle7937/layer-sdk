import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';

/// Use case for saving ocra secret key.
class SaveAccessPinUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [SaveAccessPinUseCase] use case.
  SaveAccessPinUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns `true` if access pin is saved.
  Future<bool> call({required String value}) async {
    return await _secureStorage.setString(
      key: StorageKeys.accessPin,
      value: value,
    );
  }
}
