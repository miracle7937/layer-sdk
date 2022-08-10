import 'package:collection/collection.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models/setting/global_setting.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository that can be used to fetch global console settings.
class GlobalSettingRepository implements GlobalSettingRepositoryInterface {
  final GlobalSettingProvider _provider;

  /// Creates [GlobalSettingRepository].
  GlobalSettingRepository({
    required GlobalSettingProvider provider,
  }) : _provider = provider;

  /// Returns the global settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  /// Invalid settings will be skipped.
  Future<List<GlobalSetting>> list({
    List<String>? codes,
    bool forceRefresh = false,
  }) async {
    final dtos = await _provider.list(
      codes: codes,
      forceRefresh: forceRefresh,
    );

    return dtos
        .map(
          (dto) => dto.toGlobalSetting(),
        )
        .whereNotNull()
        .toList(growable: false);
  }
}
