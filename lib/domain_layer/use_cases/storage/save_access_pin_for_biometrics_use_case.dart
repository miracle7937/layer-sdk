import 'package:biometric_storage/biometric_storage.dart';

import '../../../presentation_layer/resources.dart';
import '../../errors.dart';

/// Use case for saving ocra secret key for biometrics.
///
/// Throws [BiometricsNotAvailableException] if saving is attempted on a device
/// that does not support biometrics or has not biometrics data configured.
/// Access pin should not be saved unless the user opted for biometrics.
class SaveAccessPinForBiometricsUseCase {
  final BiometricStorage _storage;

  /// Creates a new [SaveAccessPinForBiometricsUseCase] use case.
  SaveAccessPinForBiometricsUseCase({
    required BiometricStorage storage,
  }) : _storage = storage;

  /// Saves the access pin in the biometrics secure storage.
  Future<void> call({required String value}) async {
    final feasibility = await _storage.canAuthenticate();
    if (feasibility != CanAuthenticateResponse.success) {
      throw BiometricsNotAvailableException();
    }

    final storageFile = await _storage.getStorage(StorageKeys.accessPin);

    await storageFile.write(value);
  }
}
