import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles Loyalty points transaction data
class LoyaltyPointsTransactionRepository
    implements LoyaltyPointsTransactionRepositoryInterface {
  final LoyaltyPointsTransactionProvider _provider;

  ///  Creates a new repository with
  /// the supplied [LoyaltyPointsTransactionProvider]
  LoyaltyPointsTransactionRepository(LoyaltyPointsTransactionProvider provider)
      : _provider = provider;

  /// Fetches loyalty points transactions data and
  /// parses to [LoyaltyPointsTransaction] models
  @override
  Future<List<LoyaltyPointsTransaction>> listTransactions({
    LoyaltyPointsTransactionType? transactionType,
    int? offset,
    int? limit,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    final response = await _provider.fetchLoyaltyTransactions(
      transactionType: transactionType?.toLoyaltyPointsTransactionTypeDTO() ??
          LoyaltyPointsTransactionTypeDTO.none,
      offset: offset,
      limit: limit,
      searchQuery: searchQuery,
      forceRefresh: forceRefresh,
    );
    return response
        .map((it) => it.toLoyaltyPointsTransaction())
        .toList(growable: false);
  }
}
