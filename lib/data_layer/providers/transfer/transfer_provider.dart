import '../../dtos.dart';
import '../../network.dart';

/// Provides data about the Transfers
class TransferProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [TransferProvider] with the supplied netClient.
  TransferProvider(
    this.netClient,
  );

  /// Returns a list of transfers.
  Future<List<TransferDTO>> list({
    required String customerId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    bool includeDetails = true,
    bool recurring = false,
  }) async {
    final params = <String, dynamic>{};

    if (limit != null) params['limit'] = limit;
    if (offset != null) params['offset'] = offset;
    if (recurring) params['recurring'] = recurring;
    params['includeDetails'] = includeDetails;
    params['transfer.customer_id'] = customerId;

    final response = await netClient.request(
      netClient.netEndpoints.transfer,
      method: NetRequestMethods.get,
      queryParameters: params,
      forceRefresh: forceRefresh,
    );

    return TransferDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Returns the evaluation from a transfer.
  Future<TransferEvaluationDTO> evaluate({
    required NewTransferPayloadDTO newTransferPayloadDTO,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.evaluateTransfer,
      method: NetRequestMethods.post,
      data: newTransferPayloadDTO.toJson(),
    );

    return TransferEvaluationDTO.fromJson(response.data);
  }

  /// Returns the transfer from submiting a new transfer.
  Future<TransferDTO> submit({
    required NewTransferPayloadDTO newTransferPayloadDTO,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.submitTransfer,
      method: NetRequestMethods.post,
      data: newTransferPayloadDTO.toJson(),
    );

    return TransferDTO.fromJson(response.data);
  }

  /// Returns trhe transfer dto resulting on verifying the second factor for
  /// the passed transfer id.
  Future<TransferDTO> verifySecondFactor({
    required int transferId,
    required String otpValue,
    required SecondFactorTypeDTO secondFactorTypeDTO,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.submitTransfer}?otp_value=$otpValue',
      method: NetRequestMethods.post,
      data: {
        'transfer_id': transferId,
        'second_factor': secondFactorTypeDTO.value,
      },
    );

    return TransferDTO.fromJson(response.data);
  }

  /// Resends the second factor for the passed transfer id.
  Future<TransferDTO> resendSecondFactor({
    required NewTransferPayloadDTO newTransferPayloadDTO,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.submitTransfer,
      method: NetRequestMethods.post,
      queryParameters: {'resend_otp': true},
      data: newTransferPayloadDTO.toJson(),
    );

    return TransferDTO.fromJson(response.data);
  }
}
