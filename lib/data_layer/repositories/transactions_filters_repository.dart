import '../../domain_layer/models/transactions_filters.dart';
import '../mappings/transactions_filters_mapping.dart';
import '../providers/transactions_filters_provider.dart';
import 'transactions_filters_repository_interface.dart';

///
class TransactionFiltersRepository
    implements TransactionFiltersRepositoryInterface {
  final TransactionFiltersProvider _provider;

  /// Creates a new [TransactionFiltersRepository] instance
  TransactionFiltersRepository(this._provider);

  /// Returns the filters
  @override
  Future<TransactionFilters> getMinMax({
    String? accountId,
    String? cardId,
  }) async {
    final accountTransactionsDTOs = await _provider.getMinMax(
      accountId: accountId,
      cardId: cardId,
    );

    return accountTransactionsDTOs.toTransactionFilters();
  }
}
