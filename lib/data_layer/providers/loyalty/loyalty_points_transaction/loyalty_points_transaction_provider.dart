import '../../../dtos.dart';
import '../../../network.dart';

/// Provides data for the loyalty points transactions.
class LoyaltyPointsTransactionProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [LoyaltyPointsTransactionProvider] with a [NetClient] param
  const LoyaltyPointsTransactionProvider({
    required this.netClient,
  });

  /// Returns all loyalty points transactions
  Future<List<LoyaltyPointsTransactionDTO>> fetchLoyaltyTransactions({
    LoyaltyPointsTransactionTypeDTO? transactionType,
    String? searchQuery,
    int? offset,
    int? limit,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyTransaction,
      method: NetRequestMethods.get,
      queryParameters: {
        if (transactionType != null) "txn_type": transactionType.value,
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (searchQuery != null) 'q': searchQuery,
      },
      forceRefresh: forceRefresh,
    );

    return LoyaltyPointsTransactionDTO.fromJsonList(response.data);
  }
}
