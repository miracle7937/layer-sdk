import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';
import '../../models.dart';

/// Use case for saving authentication setting.
class SaveAuthenticationSettingUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [SaveAuthenticationSettingUseCase] use case.
  SaveAuthenticationSettingUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// [GenericStorage] is the storage solution to be used for user preferences.
  ///
  /// Saves an [AuthenticationSettings] to `secureStorage` and returns if
  /// successfully saved.
  Future<AuthenticationSettings> call({
    String? defaultUsername,
    String? domain,
    bool? useBiometrics,
  }) async {
    final savedDomain = domain != null
        ? await _secureStorage.setString(
            key: StorageKeys.authDomain,
            value: domain,
          )
        : false;

    final savedUsername = defaultUsername != null
        ? await _secureStorage.setString(
            key: StorageKeys.authDefaultUsername,
            value: defaultUsername,
          )
        : false;

    final savedBiometrics = useBiometrics != null
        ? await _secureStorage.setBool(
            key: StorageKeys.authUseBiometrics,
            value: useBiometrics,
          )
        : false;

    final authenticationSettings = AuthenticationSettings(
        domain: savedDomain ? domain : null,
        defaultUsername: savedUsername ? defaultUsername : null,
        useBiometrics: savedBiometrics ? useBiometrics : false);

    return authenticationSettings;
  }
}
