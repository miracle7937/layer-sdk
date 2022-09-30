import '../../data_layer/repositories/banking_product_transactions_repository_interface.dart';
import '../../data_layer/repositories/min_max_amount_transaction_repository_interface.dart';
import '../models/banking_product_transaction.dart';
import '../models/min_max_transaction_amount.dart';

/// Use case for the banking product transactions from a customer.
class GetMinMaxTransactionAmountUseCase {
  final MinMaxTransactionAmountRepositoryInterface _repository;

  /// Creates a new [GetMinMaxTransactionAmountUseCase].
  const GetMinMaxTransactionAmountUseCase({
    required MinMaxTransactionAmountRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the banking product transactions
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<MinMaxTransactionAmount> call({
    String? accountId,
    String? cardId,
  }) =>
      _repository.getMinMax(
        accountId: accountId,
        cardId: cardId,
      );
}
