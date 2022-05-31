import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the accounts data
class AccountRepository implements AccountRepositoryInterface {
  final AccountProvider _provider;

  /// Creates a new [AccountRepository] instance
  AccountRepository(this._provider);

  /// Retrieves a list of accounts.
  ///
  /// Provide the [customerId] parameter for getting the accounts
  /// from that customer.
  @override
  Future<List<Account>> list({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
    List<AccountStatus> statuses = const [],
  }) async {
    final accountDTOs = await _provider.list(
      customerId: customerId,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
      statuses: statuses,
    );

    return accountDTOs.map((x) => x.toAccount()).toList(growable: false);
  }
}
