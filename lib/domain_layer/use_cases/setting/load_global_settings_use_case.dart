import '../../abstract_repositories/setting/global_setting_repository_interface.dart';
import '../../models/setting/global_setting.dart';

/// Use case that loads the global settings
class LoadGlobalSettingsUseCase {
  final GlobalSettingRepositoryInterface _repository;

  /// Creates a new [LoadGlobalSettingsUseCase]
  LoadGlobalSettingsUseCase({
    required GlobalSettingRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the global settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  /// Invalid settings will be skipped.
  Future<List<GlobalSetting>> call({
    String? module,
    List<String>? codes,
    List<GlobalSetting<dynamic>>? currentSettings,
    bool forceRefresh = false,
  }) {
    if (!forceRefresh) {
      final currentCodes = currentSettings?.map((e) => e.code).toList() ?? [];
      codes = codes?.where((code) => !currentCodes.contains(code)).toList();
    }

    return _repository.list(
      module: module,
      codes: codes,
      forceRefresh: forceRefresh,
    );
  }
}
