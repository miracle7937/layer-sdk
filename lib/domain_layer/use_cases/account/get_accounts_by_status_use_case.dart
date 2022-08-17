import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for getting the accounts that belongs to the passed status.
class GetAccountsByStatusUseCase {
  final AccountRepositoryInterface _repository;

  /// Creates a new [GetAccountsByStatusUseCase].
  const GetAccountsByStatusUseCase({
    required AccountRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts filtering by status.
  Future<List<Account>> call({
    required List<AccountStatus> statuses,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    assert(statuses.isNotEmpty);

    final accounts = await _repository.list(
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
      statuses: statuses,
    );

    return accounts;
  }
}
