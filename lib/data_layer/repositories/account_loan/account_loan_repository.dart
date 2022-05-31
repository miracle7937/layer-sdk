import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the accounts loans data
class AccountLoanRepository implements AccountLoanRepositoryInterface {
  final AccountLoanProvider _provider;

  /// Creates a new [AccountLoanRepository] instance.
  AccountLoanRepository(this._provider);

  /// Returns all loans associated with the supplied [customerId]
  /// or [accountId].
  ///
  /// If [includeDetails] parameter is true the data will contain
  /// the loan payments.
  @override
  Future<List<AccountLoan>> listCustomerAccountLoans({
    String? customerId,
    String? accountId,
    bool includeDetails = false,
    bool forceRefresh = false,
    int? limit,
    int? offset,
  }) async {
    assert(customerId != null || accountId != null);

    final dtos = await _provider.listAccountLoans(
      customerId: customerId,
      accountId: accountId,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
      limit: limit,
      offset: offset,
    );

    return dtos.map((x) => x.toAccountLoan()).toList(growable: false);
  }

  /// Returns an account loan associated with an id.
  ///
  /// If [includeDetails] parameter is true the data will contain
  /// the account and loan payments.
  @override
  Future<AccountLoan> getAccountLoan({
    required int id,
    bool forceRefresh = false,
    bool includeDetails = false,
  }) async {
    final dto = await _provider.getAccountLoan(
      id: id,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
    );

    return dto.toAccountLoan();
  }
}
