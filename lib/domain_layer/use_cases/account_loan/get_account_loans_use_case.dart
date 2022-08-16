import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for getting the account loans from an account id.
class GetAccountLoansUseCase {
  final AccountLoanRepositoryInterface _repository;

  /// Creates a new [GetAccountLoansUseCase].
  const GetAccountLoansUseCase({
    required AccountLoanRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts loans of the provided account id.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<AccountLoan>> call({
    required String accountId,
    bool includeDetails = true,
    bool forceRefresh = false,
    int? limit,
    int? offset,
  }) =>
      _repository.listCustomerAccountLoans(
        accountId: accountId,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
      );
}
