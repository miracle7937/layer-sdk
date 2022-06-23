import '../../dtos.dart';
import '../../network.dart';

/// Provides data related to audits
class AuditProvider {
  /// NetClient used for network requests
  final NetClient netClient;

  /// Creates a new [AuditProvider]
  AuditProvider({
    required this.netClient,
  });

  /// Returns the audits of the provided customer
  Future<List<AuditDTO>> listCustomerAudits({
    required String customerID,
    int? limit,
    int? offset,
    String? sortBy,
    bool descendingOrder = true,
    bool forceRefresh = false,
    String? searchText,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customerAudits,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
      queryParameters: {
        'customer_id': customerID,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        'desc': descendingOrder,
        if (sortBy?.isNotEmpty ?? false) 'sortby': sortBy,
        if (searchText?.isNotEmpty ?? false) 'q': searchText,
      },
    );

    return AuditDTO.fromJsonList(response.data);
  }
}
