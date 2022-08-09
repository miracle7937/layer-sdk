import '../../../features/accounts.dart';

/// Returns the account with biggest available balance to preselect
class GetPreselectedAccountForOwnTransferUseCase {
  /// Creates a new [GetPreselectedAccountForOwnTransferUseCase] use case.
  final List<Account> _accounts;

  ///
  const GetPreselectedAccountForOwnTransferUseCase(
    List<Account> accounts,
  ) : _accounts = accounts;

  /// Returns the account with biggest available balance to preselect
  Account call() {
    var preselectedAccount;
    var sortedAccounts = _accounts;
    if (sortedAccounts.isNotEmpty) {
      sortedAccounts.sort((a, b) =>
          (a.availableBalance ?? 0).compareTo((b.availableBalance ?? 0)));
      preselectedAccount = sortedAccounts.last;
    }
    return preselectedAccount;
  }
}
