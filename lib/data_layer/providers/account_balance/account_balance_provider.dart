import '../../dtos.dart';
import '../../dtos/account_transfaction/account_balance_dto.dart';
import '../../network.dart';

/// Provides data related to account balances
class AccountBalanceProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [AccountBalanceProvider] instance
  AccountBalanceProvider(
    this.netClient,
  );

  /// Returns all  balances of the supplied customer account
  Future<List<AccountBalanceDTO>> getBalance({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.balance,
      method: NetRequestMethods.get,
      queryParameters: {
        'interval': interval,
        'from_date': fromDate,
        'to_date': toDate,
        'account_id': accountId,
      },
    );

    return AccountBalanceDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }
}
