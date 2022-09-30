import '../dtos/min_max_transaction_amount_dto.dart';
import '../network/net_client.dart';
import '../network/net_request_methods.dart';

///
class MinMaxTransactionAmountProvider {
  ///
  final NetClient netClient;

  /// Creates a new [MinMaxTransactionAmountProvider] instance
  MinMaxTransactionAmountProvider(
    this.netClient,
  );

  ///
  Future<MinMaxTransactionAmountDTO> getMinMax({
    String? accountId,
    String? cardId,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.filterTransaction,
      method: NetRequestMethods.get,
      queryParameters: {
        if (accountId != null) 'account_id': accountId,
        if (cardId != null) 'card_id': cardId,
        'status': 'C,P',
      },
    );

    return MinMaxTransactionAmountDTO.fromJson(
        Map<String, dynamic>.from(response.data));
  }
}
