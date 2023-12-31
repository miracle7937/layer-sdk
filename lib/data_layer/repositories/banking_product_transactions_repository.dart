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

  Future<List<int>> getTransactionReceipt(
      BankingProductTransaction transaction) async {
    final receipt = await _provider.getTransactionReceipt(
      transaction,
    );
    return receipt;
  }

  /// Returns all completed transactions of the supplied customer
  /// banking product
  @override
  Future<List<BankingProductTransaction>>
      listCustomerBankingProductTransactions({
    String? accountId,
    String? cardId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    String? searchString,
    bool? credit,
    double? amountFrom,
    double? amountTo,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final accountTransactionsDTOs =
        await _provider.listCustomerBankingProductTransactions(
      accountId: accountId,
      cardId: cardId,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
      searchString: searchString,
      credit: credit,
      amountFrom: amountFrom,
      amountTo: amountTo,
      startDate: startDate,
      endDate: endDate,
    );

    return accountTransactionsDTOs
        .map((x) => x.toBankingProductTransaction())
        .toList(growable: false);
  }
}
