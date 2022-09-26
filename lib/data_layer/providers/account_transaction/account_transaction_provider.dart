import '../../dtos.dart';
import '../../network.dart';

/// Provides data related to account transactions
class AccountTransactionProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [AccountTransactionProvider] instance
  AccountTransactionProvider(
    this.netClient,
  );

  /// Returns all completed transactions of the supplied customer account
  Future<List<AccountTransactionDTO>> listCustomerAccountTransactions({
    required String accountId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    int? fromDate,
    int? toDate,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.transaction,
      method: NetRequestMethods.get,
      queryParameters: {
        'account_id': accountId,
        'status': 'C',
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
      },
      forceRefresh: forceRefresh,
    );

    return AccountTransactionDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }
}
