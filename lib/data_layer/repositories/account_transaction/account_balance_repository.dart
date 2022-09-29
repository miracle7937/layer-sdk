import '../../../domain_layer/abstract_repositories/account_transaction/account_balance_repository_interface.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/models/account_transaction/account_balance.dart';
import '../../mappings.dart';
import '../../providers/account_balance/account_balance_provider.dart';

/// Handles all the account balance data
class AccountBalanceRepository implements AccountBalanceRepositoryInterface {
  final AccountBalanceProvider _provider;

  /// Creates a new [AccountBalanceRepository] instance
  AccountBalanceRepository(this._provider);

  // Returns all completed balance of the supplied customer account
  @override
  Future<List<AccountBalance>> getBalance({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  }) async {
    final accountBalancesDTOs = await _provider.getBalance(
      accountId: accountId,
      fromDate: fromDate,
      toDate: toDate,
      interval: interval,
    );
    return accountBalancesDTOs
        .map((x) => x.toAccountBalance())
        .toList(growable: false);
  }
}
