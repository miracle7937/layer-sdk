import '../../domain_layer/models/banking_product_transaction.dart';
import '../mappings/banking_product_dto_mapping.dart';
import '../providers/banking_product_transactions_provider.dart';
import 'banking_product_transactions_repository_interface.dart';

/// Handles all the banking product transactions data
class BankingProductTransactionRepository
    implements BankingProductTransactionRepositoryInterface {
  final BankingProductTransactionProvider _provider;

  /// Creates a new [BankingProductTransactionRepository] instance
  BankingProductTransactionRepository(this._provider);

  /// Returns all completed transactions of the supplied customer banking product
  @override
  Future<List<BankingProductTransaction>>
      listCustomerBankingProductTransactions({
    String? accountId,
    String? cardId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  }) async {
    final accountTransactionsDTOs =
        await _provider.listCustomerBankingProductTransactions(
      accountId: accountId,
      cardId: cardId,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
    );

    return accountTransactionsDTOs
        .map((x) => x.toBankingProductTransaction())
        .toList(growable: false);
  }
}
