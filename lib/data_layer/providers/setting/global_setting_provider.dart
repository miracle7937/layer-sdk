import '../../../../data_layer/network.dart';
import '../../dtos.dart';

/// A provider that handles API requests related to the [GlobalSettingDTO].
class GlobalSettingProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [GlobalSettingProvider].
  GlobalSettingProvider({
    required this.netClient,
  });

  /// Returns the global settings.
  ///
  /// Optional [codes] parameter can be supplied to only fetch
  /// specific settings.
  Future<List<GlobalSettingDTO>> list({
    String? module,
    List<String>? codes,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.settings,
      queryParameters: {
        if (module != null) 'module': module,
        if (codes?.isNotEmpty ?? false) 'codes': codes!.join(','),
      },
      forceRefresh: forceRefresh,
      addLanguage: false,
      useDefaultToken: true,
    );

    return GlobalSettingDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
