import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for getting the accounts from a customer id.
class GetCustomerAccountsUseCase {
  final AccountRepositoryInterface _repository;

  /// Creates a new [GetCustomerAccountsUseCase].
  const GetCustomerAccountsUseCase({
    required AccountRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts belonging to customer with [customerId], if passed.
  Future<List<Account>> call({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
    List<AccountStatus> statuses = const [],
    AccountFilter? filter,
  }) async {
    final accounts = await _repository.list(
      customerId: customerId,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
      statuses: statuses,
    );

    if (filter == null) {
      return accounts;
    }

    return accounts
        .where((account) =>
            (filter.canRequestCertificateOfDeposit &&
                account.canRequestCertificateOfDeposit) ||
            (filter.canRequestCertificateOfAccount &&
                account.canRequestCertificateOfAccount) ||
            (filter.canRequestStatement && account.canRequestStatement))
        .toList(growable: false);
  }
}
