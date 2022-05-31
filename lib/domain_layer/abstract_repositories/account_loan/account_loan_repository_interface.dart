import '../../models.dart';

/// The abstract repository for the account loans.
// ignore: one_member_abstracts
abstract class AccountLoanRepositoryInterface {
  /// Returns all loans associated with the supplied [customerId]
  /// or [accountId].
  Future<List<AccountLoan>> listCustomerAccountLoans({
    String? customerId,
    String? accountId,
    bool includeDetails,
    bool forceRefresh,
    int? limit,
    int? offset,
  });

  /// Returns an account loan associated with an id.
  Future<AccountLoan> getAccountLoan({
    required int id,
    bool forceRefresh,
    bool includeDetails,
  });
}
