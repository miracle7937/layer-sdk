import '../../domain_layer/models/banking_product_transaction.dart';
import '../../domain_layer/models/min_max_transaction_amount.dart';
import '../mappings/banking_product_dto_mapping.dart';
import '../mappings/min_max_transaction_amount_mapping.dart';
import '../providers/banking_product_transactions_provider.dart';
import '../providers/min_max_amount_transaction_provider.dart';
import 'banking_product_transactions_repository_interface.dart';
import 'min_max_amount_transaction_repository_interface.dart';

/// Handles all the banking product transactions data
class MinMaxTransactionAmountRepository
    implements MinMaxTransactionAmountRepositoryInterface {
  final MinMaxTransactionAmountProvider _provider;

  /// Creates a new [MinMaxTransactionAmountRepository] instance
  MinMaxTransactionAmountRepository(this._provider);

  /// Returns all completed transactions of the supplied customer
  /// banking product
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
