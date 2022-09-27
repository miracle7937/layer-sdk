import '../../models.dart';

/// The abstract repository for the account balances.
abstract class AccountBalanceRepositoryInterface {
  /// Returns all completed balances of the supplied customer account
  Future<List<AccountBalance>> getBalance({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  });
}
