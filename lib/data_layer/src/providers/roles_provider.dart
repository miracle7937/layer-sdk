import '../../network.dart';
import '../dtos.dart';

/// Provides data about the customer roles
class RolesProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [RolesProvider] instance
  RolesProvider({
    required this.netClient,
  });

  /// Returns all available customer roles.
  Future<List<RoleDTO>> listCustomerRoles({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customerRoles,
      forceRefresh: forceRefresh,
    );

    if (response.data is List) {
      return RoleDTO.fromJsonList(response.data);
    }

    return [];
  }
}
