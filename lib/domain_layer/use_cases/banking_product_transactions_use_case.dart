import '../../data_layer/repositories/banking_product_transactions_repository_interface.dart';
import '../models/banking_product_transaction.dart';

/// Use case for the account transactions from a customer.
class GetCustomerBankingProductTransactionsUseCase {
  final BankingProductTransactionRepositoryInterface _repository;

  /// Creates a new [GetCustomerBankingProductTransactionsUseCase].
  const GetCustomerBankingProductTransactionsUseCase({
    required BankingProductTransactionRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts transactions of the provided customer id and account
  /// id.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<BankingProductTransaction>> call({
    String? accountId,
    String? cardId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    int? fromDate,
    int? toDate,
  }) =>
      _repository.listCustomerBankingProductTransactions(
        accountId: accountId,
        cardId: cardId,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
      );
}
