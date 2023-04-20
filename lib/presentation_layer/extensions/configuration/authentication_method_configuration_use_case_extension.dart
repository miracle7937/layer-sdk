import 'package:biometric_storage/biometric_storage.dart';

import '../../../domain_layer/use_cases.dart';
import '../../app/configuration/authentication_method_configuration.dart';

/// Extension responsible for selecting a proper
/// [GetOcraPasswordWithBiometricsUseCase] implementation based on the
/// [AuthenticationMethodConfiguration].
extension AuthenticationMethodConfigurationUseCaseExtension
    on AuthenticationMethodConfiguration {
  /// Returns the specific implementation of the
  /// [GetOcraPasswordWithBiometricsUseCase] depending on the
  /// [AuthenticationMethodConfiguration].
  GetOcraPasswordWithBiometricsUseCase getUseCase({
    required BiometricStorage storage,
  }) {
    switch (this) {
      case AuthenticationMethodConfiguration.accessPin:
        return GetAccessPinWithBiometricsUseCase(
          storage: storage,
        );

      default:
        throw UnimplementedError(
          'Authentication methods other than access pin '
          'are not supported for now.',
        );
    }
  }
}
