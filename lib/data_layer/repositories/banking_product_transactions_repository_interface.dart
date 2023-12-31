import '../../domain_layer/models/banking_product_transaction.dart';

/// The abstract repository for the account transactions.
// ignore: one_member_abstracts
abstract class BankingProductTransactionRepositoryInterface {
  /// Returns all completed transactions of the supplied customer account
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
  });

  /// Exports transaction receipt
  Future<List<int>> getTransactionReceipt(
    BankingProductTransaction transaction,
  );
}
