import '../../abstract_repositories/card/card_repository_interface.dart';
import '../../models/card/card_transaction.dart';

/// Use case responsible of loading customer card transactions
class LoadCustomerCardTransactionsUseCase {
  final CardRepositoryInterface _repository;

  /// Creates a new [LoadCustomerCardTransactionsUseCase]
  LoadCustomerCardTransactionsUseCase({
    required CardRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns all completed transactions of the supplied customer card
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<CardTransaction>> call({
    required String cardId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) =>
      _repository.listCustomerCardTransactions(
        cardId: cardId,
        customerId: customerId,
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
      );
}
