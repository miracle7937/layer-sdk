import '../../dtos.dart';
import '../../network.dart';

/// Provides data related to account loans
class AccountLoanProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [AccountLoansProvider] instance
  AccountLoanProvider(
    this.netClient,
  );

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
    int? limit,
    int? offset,
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
