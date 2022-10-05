import '../../domain_layer/models/transactions_filters.dart';

/// Repository interface to return the filters
abstract class TransactionFiltersRepositoryInterface {
  /// Returns the filters
  Future<TransactionFilters> getMinMax({
    String? accountId,
    String? cardId,
  });
}
