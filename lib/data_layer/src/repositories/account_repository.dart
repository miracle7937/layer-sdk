import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the accounts data
class AccountRepository {
  final AccountProvider _provider;

  /// Creates a new [AccountRepository] instance
  AccountRepository(this._provider);

  /// Retrieves all the accounts of the supplied customer
  Future<List<Account>> listCustomerAccounts({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
    AccountFilter? filter,
    List<AccountStatus> statuses = const [],
  }) async {
    final accountDTOs = await _provider.listCustomerAccounts(
      customerId: customerId,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
      statuses: statuses,
    );

    if (filter == null) {
      return accountDTOs.map((x) => x.toAccount()).toList(growable: false);
    }

    return accountDTOs
        .where((x) =>
            (filter.canRequestCertificateOfDeposit &&
                x.canRequestCertificateOfDeposit) ||
            (filter.canRequestCertificateOfAccount &&
                x.canRequestCertificateOfAccount) ||
            (filter.canRequestStatement && x.canRequestStatement))
        .map((x) => x.toAccount())
        .toList(growable: false);
  }

  /// Returns all completed transactions of the supplied customer account
  Future<List<AccountTransaction>> listCustomerAccountTransactions({
    required String accountId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final accountTransactionsDTOs =
        await _provider.listCustomerAccountTransactions(
      accountId: accountId,
      customerId: customerId,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
    );

    return accountTransactionsDTOs
        .map((x) => x.toAccountTransaction())
        .toList(growable: false);
  }

  /// Returns all loans associated with the supplied [customerId]
  /// or [accountId].
  ///
  /// If [includeDetails] parameter is true the data will contain
  /// the loan payments.
  Future<List<AccountLoan>> listCustomerAccountLoans({
    String? customerId,
    String? accountId,
    bool includeDetails = false,
    bool forceRefresh = false,
    int? limit = 50,
    int? offset = 0,
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
