import '../../abstract_repositories.dart';
import '../../abstract_repositories/account_transaction/account_balance_repository_interface.dart';
import '../../models.dart';

/// Use case for the account balances from a customer.
class GetCustomerAccountBalanceUseCase {
  final AccountBalanceRepositoryInterface _repository;

  /// Creates a new [GetCustomerAccountBalanceUseCase].
  const GetCustomerAccountBalanceUseCase({
    required AccountBalanceRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts balances of the provided customer id and account
  /// id.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<AccountBalance>> call({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  }) =>
      _repository.getBalance(
        accountId: accountId,
        interval: interval,
        fromDate: fromDate,
        toDate: toDate,
      );
}
