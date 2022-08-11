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

  /// Resends the one time password to the customer
  Future<PaymentDTO> resendOTP({
    required PaymentDTO payment,
  }) async {
    final requestParams = {
      "resend_otp": true,
    };

    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: NetRequestMethods.post,
      data: payment.toJson(),
      forceRefresh: true,
      queryParameters: requestParams,
    );

    return PaymentDTO.fromJson(response.data);
  }

  /// Delete a payment
  Future<PaymentDTO> deletePaymentV2(
    String id, {
    String? otpValue,
    bool resendOTP = false,
  }) async {
    final params = <String, dynamic>{};
    final body = <dynamic, dynamic>{};

    if (resendOTP) {
      params['resend_otp'] = 'true';
    }

    if (otpValue != null) {
      params['second_factor_verification'] = 'true';
      params['otp_value'] = otpValue;
    }

    final response = await netClient.request(
      '${netClient.netEndpoints.paymentV2}/$id',
      queryParameters: params,
      data: body,
      method: NetRequestMethods.delete,
    );

    return PaymentDTO.fromJson(response.data);
  }
}
