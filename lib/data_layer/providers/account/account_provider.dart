import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
import '../../network.dart';

/// Provides data related to Accounts
class AccountProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [AccountProvider] instance
  AccountProvider(
    this.netClient,
  );

  /// Returns a list of accounts.
  Future<List<AccountDTO>> list({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
    List<AccountStatus> statuses = const [],
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.account,
      method: NetRequestMethods.get,
      queryParameters: {
        if (customerId != null) 'customer_id': customerId,
        if (statuses.isNotEmpty)
          'status': statuses.map((e) => e.toAccountDTOStatus().value).join(','),
        'include_details': includeDetails,
      },
      forceRefresh: forceRefresh,
    );

    return AccountDTO.fromJsonList(response.data);
  }

  /// Returns all completed transactions of the supplied customer account
  Future<List<AccountTransactionDTO>> listCustomerAccountTransactions({
    required String accountId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.transaction,
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_id': customerId,
        'account_id': accountId,
        'status': 'C',
        'limit': limit,
        'offset': offset,
      },
      forceRefresh: forceRefresh,
    );

    return AccountTransactionDTO.fromJsonList(response.data);
  }

  /// Returns all loans associated with the supplied [customerId]
  /// or [accountId].
  ///
  /// If [includeDetails] parameter is true the data will contain
  /// the account and loan payments.
  Future<List<AccountLoanDTO>> listAccountLoans({
    String? customerId,
    String? accountId,
    bool includeDetails = false,
    bool forceRefresh = false,
    int? limit = 50,
    int? offset = 0,
  }) async {
    assert(customerId != null || accountId != null);

    final response = await netClient.request(
      netClient.netEndpoints.accountLoan,
      method: NetRequestMethods.get,
      queryParameters: {
        if (customerId != null) 'customer_id': customerId,
        if (accountId != null) 'account_id': accountId,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        'include_details': includeDetails,
        'sortby': 'next_payment_date',
        'desc': true,
      },
      forceRefresh: forceRefresh,
    );

    return AccountLoanDTO.fromJsonList(response.data);
  }

  /// Returns an account loan associated with an id.
  ///
  /// If [includeDetails] parameter is true the data will contain
  /// the account and loan payments.
  Future<AccountLoanDTO> getAccountLoan({
    required int id,
    bool includeDetails = false,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.accountLoan,
      method: NetRequestMethods.get,
      queryParameters: {
        'account_loan_id': id,
        'include_details': includeDetails,
      },
      forceRefresh: forceRefresh,
    );

    return AccountLoanDTO.fromJson(response.data.first);
  }
}
