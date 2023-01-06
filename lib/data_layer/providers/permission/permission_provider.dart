import '../../dtos.dart';
import '../../network.dart';

/// A provider for permission module data.
class PermissionProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates a [PermissionProvider].
  PermissionProvider({
    required this.netClient,
  });

  /// Returns the list of permission objects with its descriptions.
  Future<List<PermissionDTO>> listPermissions() async {
    final response = await netClient.request(
      (netClient.netEndpoints as ConsoleEndpoints).customerPermissions,
    );

    if (response.data is List) {
      return PermissionDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data),
      );
    }

    return [];
  }
}
