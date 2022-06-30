import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for getting an account loan by its id.
class GetAccountLoanByIdUseCase {
  final AccountLoanRepositoryInterface _repository;

  /// Creates a new [GetAccountLoanByIdUseCase].
  const GetAccountLoanByIdUseCase({
    required AccountLoanRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the account loan that corresponds to the passed id.
  Future<AccountLoan> call({
    required int id,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) =>
      _repository.getAccountLoan(
        id: id,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
      );
}
