import '../dtos/transactions_filters_dto.dart';
import '../network/net_client.dart';
import '../network/net_request_methods.dart';

/// Returns the filters for an account id or card id
class TransactionFiltersProvider {
  ///
  final NetClient netClient;

  /// Creates a new [TransactionFiltersProvider] instance
  TransactionFiltersProvider(
    this.netClient,
  );

  /// Returns the filters for an account id or card id
  Future<TransactionFiltersDTO> getMinMax({
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

    return TransactionFiltersDTO.fromJson(
        Map<String, dynamic>.from(response.data));
  }
}
