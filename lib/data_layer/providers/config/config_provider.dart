import 'package:logging/logging.dart';

import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to configurations.
class ConfigProvider {
  final _log = Logger('ConfigProvider');

  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [ConfigProvider]
  ConfigProvider({
    required this.netClient,
  });

  /// Returns the configuration file from the connected backend.
  Future<ConfigDTO?> load({
    bool forceRefresh = true,
  }) async {
    try {
      final response = await netClient.request(
        '${netClient.netEndpoints.file}/config.json',
        forceRefresh: forceRefresh,
      );

      if (!response.success) return null;

      return ConfigDTO.fromJson(response.data);
    } on Exception {
      _log.warning('Failed to download the config file.');

      return null;
    }
  }
}
