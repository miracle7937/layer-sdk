import '../../../../data_layer/network.dart';
import '../dtos.dart';

/// A provider for permission module data.
class PermissionModuleProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates a [PermissionModuleProvider].
  PermissionModuleProvider({
    required this.netClient,
  });

  /// Returns the list of permission modules available.
  Future<List<PermissionModuleDTO>> list({
    bool customerModules = true,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      customerModules
          ? netClient.netEndpoints.customerPermissionModule
          : netClient.netEndpoints.permissionModule,
      forceRefresh: forceRefresh,
    );

    return response.data is List<Map<String, dynamic>>
        ? PermissionModuleDTO.fromJsonList(
            List<Map<String, dynamic>>.from(response.data),
          )
        : <PermissionModuleDTO>[];
  }
}
