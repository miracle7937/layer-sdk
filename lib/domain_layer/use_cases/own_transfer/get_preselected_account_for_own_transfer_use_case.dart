import '../../../features/accounts.dart';

/// Returns the account with biggest available balance to preselect
class GetPreselectedAccountForOwnTransferUseCase {
  /// Creates a new [GetPreselectedAccountForOwnTransferUseCase] use case.
  const GetPreselectedAccountForOwnTransferUseCase();

  /// Returns the account with biggest available balance to preselect
  Account? call(
    List<Account> accounts,
  ) {
    var sortedAccounts = accounts;
    if (sortedAccounts.isNotEmpty) {
      sortedAccounts.sort((a, b) =>
          (a.availableBalance ?? 0).compareTo((b.availableBalance ?? 0)));
      return sortedAccounts.last;
    }
    return null;
  }
}
