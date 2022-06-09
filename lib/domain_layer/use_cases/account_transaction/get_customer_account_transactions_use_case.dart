import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for the account transactions from a customer.
class GetCustomerAccountTransactionsUseCase {
  final AccountTransactionRepositoryInterface _repository;

  /// Creates a new [GetCustomerAccountTransactionsUseCase].
  const GetCustomerAccountTransactionsUseCase({
    required AccountTransactionRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts transactions belonging to passed the customer id.
  Future<List<AccountTransaction>> call({
    required String customerId,
    required String accountId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
  }) =>
      _repository.listCustomerAccountTransactions(
        accountId: accountId,
        customerId: customerId,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
      );
}
