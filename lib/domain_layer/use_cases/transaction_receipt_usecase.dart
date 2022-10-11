import '../../data_layer/repositories/banking_product_transactions_repository_interface.dart';
import '../models/banking_product_transaction.dart';

/// Use case for the banking product transactions receipt
class TransactionReceiptUseCase {
  final BankingProductTransactionRepositoryInterface _repository;

  /// Creates a new [TransactionReceiptUseCase].
  const TransactionReceiptUseCase({
    required BankingProductTransactionRepositoryInterface repository,
  }) : _repository = repository;

  /// Exports transaction receipt
  Future<List<int>> call(
    BankingProductTransaction transaction,
  ) =>
      _repository.getTransactionReceipt(
        transaction,
      );
}
