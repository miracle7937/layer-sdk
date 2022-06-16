import '../../models/config/config.dart';

/// An abstract repository for the config
abstract class ConfigRepositoryInterface {
  /// Loads the [Config] from the connected backend.
  Future<Config> load({bool forceRefresh = true});
}
