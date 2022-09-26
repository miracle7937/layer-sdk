import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for the account transactions from a customer.
class GetCustomerAccountTransactionsUseCase {
  final AccountTransactionRepositoryInterface _repository;

  /// Creates a new [GetCustomerAccountTransactionsUseCase].
  const GetCustomerAccountTransactionsUseCase({
    required AccountTransactionRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts transactions of the provided customer id and account
  /// id.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<AccountTransaction>> call({
    required String accountId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    int? fromDate,
    int? toDate,
  }) =>
      _repository.listCustomerAccountTransactions(
        accountId: accountId,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
        fromDate: fromDate,
        toDate: toDate,
      );
}
