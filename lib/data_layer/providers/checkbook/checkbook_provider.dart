import '../../dtos.dart';
import '../../network.dart';

/// Provides Checkbook Data
class CheckbookProvider {
  final NetClient _netClient;

  /// Creates a new [CheckbookProvider]
  CheckbookProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Returns checkbooks of the provided customer ID
  Future<List<CheckbookDTO>> listCustomerCheckbooks({
    required String customerId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    String? sortBy,
    bool descendingOrder = true,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.checkbooks,
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_id': customerId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (sortBy != null) 'sortby': sortBy,
        'desc': descendingOrder,
      },
      forceRefresh: forceRefresh,
    );

    return CheckbookDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
