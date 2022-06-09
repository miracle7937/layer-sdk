import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the account transactions data
class AccountTransactionRepository
    implements AccountTransactionRepositoryInterface {
  final AccountTransactionProvider _provider;

  /// Creates a new [AccountTransactionRepository] instance
  AccountTransactionRepository(this._provider);

  /// Returns all completed transactions of the supplied customer account
  @override
  Future<List<AccountTransaction>> listCustomerAccountTransactions({
    required String accountId,
    String? customerId,
    int? limit,
    int? offset,
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
}