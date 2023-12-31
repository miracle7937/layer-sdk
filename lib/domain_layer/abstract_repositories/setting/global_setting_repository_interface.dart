import '../../models/setting/global_setting.dart';

/// An abstract repository for global settings
abstract class GlobalSettingRepositoryInterface {
  /// Returns the global settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  /// Invalid settings will be skipped.
  Future<List<GlobalSetting>> list({
    String? module,
    List<String>? codes,
    bool forceRefresh = false,
  });
}
