import '../../models/setting/global_setting.dart';

/// An abstract repository for global settings
abstract class GlobalSettingRepositoryInterface {
  /// Returns the global settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  Future<List<GlobalSetting>> list({
    List<String>? codes,
    bool forceRefresh = false,
  });
}
