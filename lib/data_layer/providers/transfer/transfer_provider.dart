import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
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

  /// Returns a list of frequent transfers
  Future<List<TransferDTO>> loadFrequentTransfers({
    int? limit,
    int? offset,
    bool includeDetails = true,
    TransferStatus? status,
    List<TransferType>? types,
  }) async {
    final params = <String, dynamic>{};

    params['include_details'] = includeDetails;
    if (limit != null) params['limit'] = limit;
    if (offset != null) params['offset'] = offset;
    if (status != null) params['status'] = status.toJSONString;
    if (types != null && types.isNotEmpty) {
      params['trf_type'] = types.map((t) => t.toJSONString).join(',');
    }

    final response = await netClient.request(
      netClient.netEndpoints.frequentTransfers,
      method: NetRequestMethods.get,
      queryParameters: params,
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
}
