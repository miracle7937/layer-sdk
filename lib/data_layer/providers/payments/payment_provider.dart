import '../../dtos.dart';
import '../../network.dart';

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
      List.from(response.data),
    );
  }

  /// Excutes the payment
  Future<PaymentDTO> payBill({
    required PaymentDTO payment,
    String? otp,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: NetRequestMethods.post,
      data: payment.toJson(),
      forceRefresh: true,
      queryParameters: {
        if (otp?.isNotEmpty ?? false) 'otp_value': otp,
      },
    );

    return PaymentDTO.fromJson(response.data);
  }

  /// Returns the frequent payments of a customer.
  Future<List<PaymentDTO>> getFrequentPayments({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.frequentPayment,
      method: NetRequestMethods.get,
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'type': 'payment',
      },
    );

    return PaymentDTO.fromJsonList(
      List.from(response.data),
    );
  }
}
