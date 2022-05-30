import '../../../migration/data_layer/network.dart';
import '../dtos.dart';

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
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool includeDetails = true,
    bool recurring = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.transfer,
      method: NetRequestMethods.get,
      queryParameters: {
        'transfer.customer_id': customerId,
        'include_details': includeDetails,
        'limit': limit,
        'offset': offset,
        if (recurring) 'recurring': recurring,
      },
      forceRefresh: forceRefresh,
    );

    return TransferDTO.fromJsonList(response.data);
  }
}
