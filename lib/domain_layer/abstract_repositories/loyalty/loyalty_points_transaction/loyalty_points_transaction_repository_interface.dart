import '../../../models.dart';

/// The abstract repository for the loyalty points transactions.
// ignore: one_member_abstracts
abstract class LoyaltyPointsTransactionRepositoryInterface {
  /// Fetches loyalty points transactions.
  Future<List<LoyaltyPointsTransaction>> listTransactions({
    LoyaltyPointsTransactionType? transactionType,
    int? offset,
    int? limit,
    String? searchQuery,
    bool forceRefresh = false,
    DateTime? startDate,
    DateTime? endDate,
  });
}
