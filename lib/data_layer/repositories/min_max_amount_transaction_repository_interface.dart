import '../../domain_layer/models/min_max_transaction_amount.dart';

/// Repository interface to return the filters
abstract class MinMaxTransactionAmountRepositoryInterface {
  /// Returns the filters
  Future<MinMaxTransactionAmount> getMinMax({
    String? accountId,
    String? cardId,
  });
}
