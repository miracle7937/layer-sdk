import '../../dtos.dart';
import '../../network.dart';

/// Provider that handles the data for the pay to mobile flow.
class PayToMobileProvider {
  /// The NetClient to use for the network requests.
  final NetClient _netClient;

  /// Creates [PayToMobileProvider].
  PayToMobileProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Submits a new pay to mobile flow and returns a pay to mobile dto element.
  Future<PayToMobileDTO> submit({
    required NewPayToMobileDTO newPayToMobileDTO,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.sendMoney,
      method: NetRequestMethods.post,
      data: newPayToMobileDTO.toJson(),
    );

    return PayToMobileDTO.fromJson(response.data);
  }

  /// Returns the [PayToMobileDTO] resulting on sending the OTP code for the
  /// passed pay to mobile request ID.
  Future<PayToMobileDTO> sendOTPCode({
    required String requestId,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.sendMoney,
      method: NetRequestMethods.post,
      data: {
        'request_id': requestId,
        'second_factor': SecondFactorTypeDTO.otp.value,
      },
    );

    return PayToMobileDTO.fromJson(response.data);
  }

  /// Returns the [PayToMobileDTO] resulting on verifying the second factor for
  /// the passed pay to mobile request ID.
  Future<PayToMobileDTO> verifySecondFactor({
    required String requestId,
    required String value,
    required SecondFactorTypeDTO secondFactorTypeDTO,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.sendMoney,
      method: NetRequestMethods.post,
      data: {
        'request_id': requestId,
        'second_factor': secondFactorTypeDTO.value,
        if (secondFactorTypeDTO == SecondFactorTypeDTO.ocra)
          'client_response': value,
        if (secondFactorTypeDTO == SecondFactorTypeDTO.otp) 'otp_value': value,
      },
    );

    return PayToMobileDTO.fromJson(response.data);
  }

  /// Resends the second factor for the passed [PayToMobileDTO].
  Future<PayToMobileDTO> resendSecondFactor({
    required PayToMobileDTO payToMobileDTO,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.sendMoney,
      method: NetRequestMethods.post,
      queryParameters: {'resend_otp': true},
      data: payToMobileDTO.toJson(),
    );

    return PayToMobileDTO.fromJson(response.data);
  }

  /// Deletes the pay to mobile related to the passed request ID and returns
  /// that pay to mobile DTO.
  ///
  /// If the request succeded (no second factor was returned) `null` will be
  /// returned.
  Future<PayToMobileDTO?> delete({
    required String requestId,
  }) async {
    final response = await _netClient.request(
      '${_netClient.netEndpoints.sendMoney}/$requestId',
      method: NetRequestMethods.delete,
    );

    return response.data == null
        ? null
        : PayToMobileDTO.fromJson(response.data);
  }

  /// Resends the withdrawal code related to the passed request ID.
  Future<void> resendWithdrawalCode({
    required String requestId,
  }) =>
      _netClient.request(
        '${_netClient.netEndpoints.resendSendMoney}/$requestId',
        method: NetRequestMethods.post,
      );

  /// Returns the [PayToMobileDTO] resulting on sending the OTP code for
  /// deleting the passed pay to mobile request ID.
  Future<PayToMobileDTO> sendOTPCodeForDeleting({
    required String requestId,
  }) async {
    final response = await _netClient.request(
      '${_netClient.netEndpoints.sendMoney}/$requestId',
      method: NetRequestMethods.delete,
      data: {
        'second_factor': SecondFactorTypeDTO.otp.value,
      },
    );

    return PayToMobileDTO.fromJson(response.data);
  }

  /// Verifies the second factor for deleting the passed pay to mobile
  /// request ID.
  Future<void> verifySecondFactorForDeleting({
    required String requestId,
    required String value,
    required SecondFactorTypeDTO secondFactorTypeDTO,
  }) =>
      _netClient.request(
        '${_netClient.netEndpoints.sendMoney}/$requestId',
        method: NetRequestMethods.delete,
        data: {
          'second_factor': secondFactorTypeDTO.value,
          if (secondFactorTypeDTO == SecondFactorTypeDTO.ocra)
            'client_response': value,
          if (secondFactorTypeDTO == SecondFactorTypeDTO.otp)
            'otp_value': value,
        },
      );

  /// Resends the second factor for the deleting the passed [PayToMobileDTO].
  Future<PayToMobileDTO> resendSecondFactorForDeleting({
    required PayToMobileDTO payToMobileDTO,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.sendMoney,
      method: NetRequestMethods.delete,
      queryParameters: {'resend_otp': true},
      data: payToMobileDTO.toJson(),
    );

    return PayToMobileDTO.fromJson(response.data);
  }
}
