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
  Future<PaymentDTO> postPayment({
    required PaymentDTO payment,
  }) async {
    final json = payment.toJson();
    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: NetRequestMethods.post,
      data: json,
      forceRefresh: true,
    );

    return PaymentDTO.fromJson(response.data);
  }

  /// Patches the payment
  Future<PaymentDTO> patchPayment({
    required PaymentDTO payment,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: NetRequestMethods.patch,
      data: payment.toJson(),
      forceRefresh: true,
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
      ignoreRecurrence: true,
    );
  }

  /// Returns the payment dto resulting on sending the OTP code for the
  /// passed payment.
  Future<PaymentDTO> sendOTPCode({
    required PaymentDTO payment,
    required bool editMode,
  }) async {
    final paymentJson = payment.toJson();

    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: editMode ? NetRequestMethods.patch : NetRequestMethods.post,
      data: {
        ...paymentJson,
        'second_factor': SecondFactorTypeDTO.otp.value,
      },
    );

    return PaymentDTO.fromJson(response.data);
  }

  /// Returns the payment dto resulting on verifying the second factor for
  /// the passed payment.
  Future<PaymentDTO> verifySecondFactor({
    required PaymentDTO payment,
    required String value,
    required SecondFactorTypeDTO secondFactorTypeDTO,
    required bool editMode,
  }) async {
    final paymentJson = payment.toJson();

    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: editMode ? NetRequestMethods.patch : NetRequestMethods.post,
      data: {
        ...paymentJson,
        'second_factor': secondFactorTypeDTO.value,
        if (secondFactorTypeDTO == SecondFactorTypeDTO.ocra)
          'client_response': value,
        if (secondFactorTypeDTO == SecondFactorTypeDTO.otp) 'otp_value': value,
        'second_factor_verification': true
      },
    );

    return PaymentDTO.fromJson(response.data);
  }

  /// Resends second factor for the passed payment.
  Future<PaymentDTO> resendSecondFactor({
    required PaymentDTO payment,
    required bool editMode,
  }) async {
    final paymentJson = payment.toJson();

    final response = await netClient.request(
      netClient.netEndpoints.paymentV2,
      method: editMode ? NetRequestMethods.patch : NetRequestMethods.post,
      data: {
        ...paymentJson,
        'resend_otp': true,
      },
      //queryParameters: {'resend_otp': true},
      forceRefresh: true,
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
