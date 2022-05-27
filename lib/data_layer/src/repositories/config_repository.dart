import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles the config data.
class ConfigRepository {
  final ConfigProvider _configProvider;

  /// Creates a new [ConfigRepository] with the supplied [ConfigProvider]
  const ConfigRepository({
    required ConfigProvider configProvider,
  }) : _configProvider = configProvider;

  /// Returns a [Config] from the connected backend.
  Future<Config> load({
    bool forceRefresh = true,
  }) async {
    final dto = await _configProvider.load(forceRefresh: forceRefresh);

    return dto?.toConfig() ?? Config();
  }
}
