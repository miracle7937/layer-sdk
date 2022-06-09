import '../../../../data_layer/network.dart';
import '../dtos.dart';

/// Provides data about customer's payments
class PaymentProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [PaymentProvider] with the supplied [NetClient].
  PaymentProvider({
    required this.netClient,
  });

  /// Returns the payments for a customer.
  Future<List<PaymentDTO>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool recurring = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.payment,
      method: NetRequestMethods.get,
      queryParameters: {
        'payment.customer_id': customerId,
        'limit': limit,
        'offset': offset,
        if (recurring) 'payment.recurring': recurring,
      },
      forceRefresh: forceRefresh,
    );

    return PaymentDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
