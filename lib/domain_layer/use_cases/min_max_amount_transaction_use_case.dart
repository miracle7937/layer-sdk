import '../../data_layer/repositories/min_max_amount_transaction_repository_interface.dart';
import '../models/min_max_transaction_amount.dart';

/// Use case for the transaction filters
class GetMinMaxTransactionAmountUseCase {
  final MinMaxTransactionAmountRepositoryInterface _repository;

  /// Creates a new [GetMinMaxTransactionAmountUseCase].
  const GetMinMaxTransactionAmountUseCase({
    required MinMaxTransactionAmountRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the transactions filters
  Future<MinMaxTransactionAmount> call({
    String? accountId,
    String? cardId,
  }) =>
      _repository.getMinMax(
        accountId: accountId,
        cardId: cardId,
      );
}
