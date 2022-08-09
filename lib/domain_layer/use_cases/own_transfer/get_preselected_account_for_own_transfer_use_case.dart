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
  Future<Account> call() async {
    var source = _accounts[0];
    for (var element in _accounts) {
      if ((element.availableBalance ?? 0) > (source.availableBalance ?? 0)) {
        source = element;
      }
    }
    return source;
  }
}
