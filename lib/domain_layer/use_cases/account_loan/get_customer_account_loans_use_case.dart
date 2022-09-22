import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for getting the account loans from a customer id.
class GetCustomerAccountLoansUseCase {
  final AccountLoanRepositoryInterface _repository;

  /// Creates a new [GetCustomerAccountLoansUseCase].
  const GetCustomerAccountLoansUseCase({
    required AccountLoanRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts loans of the provided customer id.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<AccountLoan>> call({
    required String customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
    int? limit,
    int? offset,
  }) =>
      _repository.listCustomerAccountLoans(
        customerId: customerId,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
      );
}
