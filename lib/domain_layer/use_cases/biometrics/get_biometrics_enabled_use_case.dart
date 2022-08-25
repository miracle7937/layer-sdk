import 'package:biometrics_change_detector/biometrics_change_detector.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../../data_layer/environment.dart';
import '../../use_cases.dart';

/// Use case for getting whether the biometrics are enabled depending on the
/// console settings.
class GetBiometricsEnabledUseCase {
  /// The logger object.
  final _logger = Logger('GetBiometricsEnabledUseCase');

  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;
  final GetDeviceModelUseCase _getDeviceModelUseCase;

  /// Creates a new [GetBiometricsEnabledUseCase].
  GetBiometricsEnabledUseCase({
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
    required GetDeviceModelUseCase getDeviceModelUseCase,
  })  : _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        _getDeviceModelUseCase = getDeviceModelUseCase;

  /// Returns whether if the biometrics are enabled on the console or not.
  /// If the biometrics changed and the console has the
  /// `wipe_on_biometric_change` setting enabled, an Exception containing
  /// the `wipe_on_biometric_change` message will be thrown.
  Future<bool> call() async {
    final appId = EnvironmentConfiguration.current.experienceAppId;
    assert(appId != null, 'Please specify appId in environment configuration');

    final biometricsSettings = await _loadGlobalSettingsUseCase(
      codes: [
        'fingerprint_enabled',
        'broken_biometrics',
        'wipe_on_biometric_change',
      ],
    );

    final enabledOnConsole = biometricsSettings
            .singleWhereOrNull(
                (setting) => setting.code == 'fingerprint_enabled')
            ?.value ??
        false;

    final brokenDevices = biometricsSettings
            .singleWhereOrNull((setting) => setting.code == 'broken_biometrics')
            ?.value
            .toString()
            .split('') ??
        <String>[];

    final wipeOnBiometricsChange = biometricsSettings
            .singleWhereOrNull(
                (setting) => setting.code == 'wipe_on_biometric_change')
            ?.value ??
        false;

    if (wipeOnBiometricsChange) {
      final didChange =
          await BiometricsChangeDetector.didBiometricsChange(appId!)
              .catchError((e) {
        _logger.log(Level.SEVERE, e);
        return false;
      });

      if (didChange) {
        throw Exception('wipe_on_biometric_change');
      }
    }

    final model = await _getDeviceModelUseCase();
    final isDeviceBroken = brokenDevices.contains(model);

    return enabledOnConsole && !isDeviceBroken;
  }
}
