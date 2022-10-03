import '../../data_layer/repositories/transactions_filters_repository_interface.dart';
import '../models/transactions_filters.dart';

/// Use case for the transaction filters
class GetTransactionFiltersUseCase {
  final TransactionFiltersRepositoryInterface _repository;

  /// Creates a new [GetTransactionFiltersUseCase].
  const GetTransactionFiltersUseCase({
    required TransactionFiltersRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the transactions filters
  Future<TransactionFilters> call({
    String? accountId,
    String? cardId,
  }) =>
      _repository.getMinMax(
        accountId: accountId,
        cardId: cardId,
      );
}
