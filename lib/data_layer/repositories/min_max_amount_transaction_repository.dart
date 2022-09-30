import '../../domain_layer/models/min_max_transaction_amount.dart';
import '../mappings/min_max_transaction_amount_mapping.dart';
import '../providers/min_max_amount_transaction_provider.dart';
import 'min_max_amount_transaction_repository_interface.dart';

///
class MinMaxTransactionAmountRepository
    implements MinMaxTransactionAmountRepositoryInterface {
  final MinMaxTransactionAmountProvider _provider;

  /// Creates a new [MinMaxTransactionAmountRepository] instance
  MinMaxTransactionAmountRepository(this._provider);

  /// Returns the filters
  @override
  Future<MinMaxTransactionAmount> getMinMax({
    String? accountId,
    String? cardId,
  }) async {
    final accountTransactionsDTOs = await _provider.getMinMax(
      accountId: accountId,
      cardId: cardId,
    );

    return accountTransactionsDTOs.toMinMaxTransactionAmount();
  }
}
