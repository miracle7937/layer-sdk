import '../../dtos.dart';
import '../../network.dart';

/// Provides data about the Standing orders
class StandingOrderProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [StandingOrderProvider] with the supplied netClient.
  StandingOrderProvider(
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
}
