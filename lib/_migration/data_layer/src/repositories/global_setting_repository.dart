import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// A repository that can be used to fetch global console settings.
class GlobalSettingRepository {
  final GlobalSettingProvider _provider;

  /// Creates [GlobalSettingRepository].
  GlobalSettingRepository({
    required GlobalSettingProvider provider,
  }) : _provider = provider;

  /// Returns the global settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  Future<List<GlobalSetting>> list({
    List<String>? codes,
    bool forceRefresh = false,
  }) async {
    final dtos = await _provider.list(
      codes: codes,
      forceRefresh: forceRefresh,
    );

    return dtos.map((dto) => dto.toGlobalSetting()).toList(growable: false);
  }
}
