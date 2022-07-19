import '../../../data_layer/interfaces.dart';
import '../../../presentation_layer/resources.dart';
import '../../models.dart';

/// Use case for loading authentication settings.
class LoadAuthenticationSettingsUseCase {
  final GenericStorage _secureStorage;

  /// Creates a new [LoadAuthenticationSettingsUseCase] use case.
  LoadAuthenticationSettingsUseCase({
    required GenericStorage secureStorage,
  }) : _secureStorage = secureStorage;

  /// Returns an [AuthenticationSettings] from storage.
  Future<AuthenticationSettings> call() async {
    final domain = await _secureStorage.getString(
      key: StorageKeys.authDomain,
    );

    final defaultUsername = await _secureStorage.getString(
      key: StorageKeys.authDefaultUsername,
    );

    final useBiometrics = await _secureStorage.getBool(
      key: StorageKeys.authUseBiometrics,
    );
    final authenticationSettings = AuthenticationSettings(
        domain: domain,
        defaultUsername: defaultUsername,
        useBiometrics: useBiometrics ?? false);

    return authenticationSettings;
  }
}
