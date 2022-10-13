import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case for loading loyalty points transactions corresponding to
/// a specific [LoyaltyPointsTransactionType].
class LoadLoyaltyPointsTransactionsByTypeUseCase {
  final LoyaltyPointsTransactionRepositoryInterface _repository;

  /// Creates a new [LoadLoyaltyPointsTransactionsByTypeUseCase].
  const LoadLoyaltyPointsTransactionsByTypeUseCase({
    required LoyaltyPointsTransactionRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads loyalty points transactions related to the passed
  /// transaction type.
  Future<List<LoyaltyPointsTransaction>> call({
    required LoyaltyPointsTransactionType? transactionType,
    int? limit,
    int? offset,
    String? searchQuery,
    bool forceRefresh = false,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      _repository.listTransactions(
        transactionType: transactionType,
        limit: limit,
        offset: offset,
        searchQuery: searchQuery,
        forceRefresh: forceRefresh,
        startDate: startDate,
        endDate: endDate,
      );
}
