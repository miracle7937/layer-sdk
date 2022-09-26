import '../../models.dart';

/// The abstract repository for the account transactions.
// ignore: one_member_abstracts
abstract class AccountTransactionRepositoryInterface {
  /// Returns all completed transactions of the supplied customer account
  Future<List<AccountTransaction>> listCustomerAccountTransactions({
    required String accountId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    int? fromDate,
    int? toDate,
  });
}
