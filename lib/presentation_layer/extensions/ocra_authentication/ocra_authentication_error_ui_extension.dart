import '../../../features/ocra_authentication.dart';
import '../../utils.dart';

/// Extensions on the [OcraAuthenticationError].
extension OcraAuthenticationErrorUIExtension on OcraAuthenticationError {
  /// Localizes an [OcraAuthenticationError].
  String? localize(
    Translation translation,
    int? remainingAttempts,
  ) {
    switch (this) {
      case OcraAuthenticationError.generic:
        return translation.translate('generic_error');

      case OcraAuthenticationError.serverAuthenticationFailed:
        return translation.translate('server_authentication_failed');

      case OcraAuthenticationError.deviceInactive:
        return translation.translate('device_inactive_default_error');

      case OcraAuthenticationError.wrongPin:
        return translation.replaceVariable(
          'wrong_pin',
          ['attempts'],
          [remainingAttempts.toString()],
        );

      case OcraAuthenticationError.biometricsNotSupported:
        return translation.translate('biometrics_not_supported');

      case OcraAuthenticationError.none:
        return null;
    }
  }
}
