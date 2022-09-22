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
        'interval': 'day', // interval,
        'from_date': '1632300992000', //fromDate,
        'to_date': '1663836992000', //toDate,
        'account_id': 'a15cd2103c6472bcf78ef0ab7d765a9596b25c77', //accountId,
      },
    );

    return AccountBalanceDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }
}
