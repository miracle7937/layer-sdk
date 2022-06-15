import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles the config data.
class ConfigRepository implements ConfigRepositoryInterface {
  final ConfigProvider _configProvider;

  /// Creates a new [ConfigRepository] with the supplied [ConfigProvider]
  const ConfigRepository({
    required ConfigProvider configProvider,
  }) : _configProvider = configProvider;

  /// Returns a [Config] from the connected backend.
  @override
  Future<Config> load({
    bool forceRefresh = true,
  }) async {
    final dto = await _configProvider.load(forceRefresh: forceRefresh);

    return dto?.toConfig() ?? Config();
  }
}
