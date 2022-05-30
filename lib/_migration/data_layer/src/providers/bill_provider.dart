import '../../../../data_layer/network.dart';
import '../dtos.dart';

/// Provides data about customer's bills
class BillProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BillProvider] with the supplied [NetClient].
  BillProvider({
    required this.netClient,
  });

  /// Returns the bills for a customer.
  Future<List<BillDTO>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.bill,
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_id': customerId,
        'limit': limit,
        'offset': offset,
      },
      forceRefresh: forceRefresh,
    );

    return BillDTO.fromJsonList(response.data);
  }
}
