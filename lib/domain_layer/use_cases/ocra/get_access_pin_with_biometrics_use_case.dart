import 'package:biometric_storage/biometric_storage.dart';

import '../../../presentation_layer/resources.dart';
import '../../errors.dart';
import 'get_ocra_password_with_biometrics_use_case.dart';

/// The use case responsible for retrieving the access pin value from the
/// biometrics secure storage to be used in the OCRA flow.
///
/// Throws [BiometricsNotAvailableException] if the device does not support
/// biometrics or has no biometrics data configured.
class GetAccessPinWithBiometricsUseCase
    implements GetOcraPasswordWithBiometricsUseCase {
  final BiometricStorage _storage;

  /// Creates new [GetAccessPinWithBiometricsUseCase].
  GetAccessPinWithBiometricsUseCase({
    required BiometricStorage storage,
  }) : _storage = storage;

  @override
  Future<String> call({
    String promptTitle = '',
  }) async {
    final feasibility = await _storage.canAuthenticate();
    if (feasibility != CanAuthenticateResponse.success) {
      throw BiometricsNotAvailableException();
    }

    final storageFile = await _storage.getStorage(
      StorageKeys.accessPin,
      options: StorageFileInitOptions(
        androidBiometricOnly: true,
        authenticationRequired: true,
        authenticationValidityDurationSeconds: -1,
      ),
      promptInfo: promptTitle.isNotEmpty
          ? PromptInfo(
              androidPromptInfo: AndroidPromptInfo(
                title: promptTitle,
              ),
              iosPromptInfo: IosPromptInfo(
                accessTitle: promptTitle,
              ),
            )
          : PromptInfo.defaultValues,
    );

    final pin = await storageFile.read();
    return pin ?? '';
  }
}
