import '../dtos/banking_product_transaction_dto.dart';
import '../network/net_client.dart';
import '../network/net_request_methods.dart';

/// Provides data related to account transactions
class BankingProductTransactionProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BankingProductTransactionProvider] instance
  BankingProductTransactionProvider(
    this.netClient,
  );

  /// Returns all completed transactions of the supplied customer account
  Future<List<BankingProductTransactionDTO>>
      listCustomerBankingProductTransactions({
    String? accountId,
    String? cardId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    String? searchString,
    bool? credit,
    int? amountFrom,
    int? amountTo,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.transaction,
      method: NetRequestMethods.get,
      queryParameters: {
        if (accountId != null) 'account_id': accountId,
        'status': 'C',
        if (cardId != null) 'card_id': cardId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (amountFrom != null) 'from_amount': amountFrom,
        if (amountTo != null) 'to_amount': amountTo,
        if (startDate != null) 'ts_from': startDate.millisecondsSinceEpoch,
        if (endDate != null) 'ts_to': endDate.millisecondsSinceEpoch,
        if (credit != null && credit) 'credit': true,
        if (credit != null && !credit) 'debit': true,
        if (searchString != null) 'q': searchString,
      },
      forceRefresh: forceRefresh,
    );

    return BankingProductTransactionDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }
}
