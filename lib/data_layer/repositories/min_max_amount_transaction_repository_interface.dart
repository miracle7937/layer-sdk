import '../../domain_layer/models/min_max_transaction_amount.dart';

/// The abstract repository for the account transactions.
// ignore: one_member_abstracts
abstract class MinMaxTransactionAmountRepositoryInterface {
  /// Returns all completed transactions of the supplied customer account
  Future<MinMaxTransactionAmount> getMinMax({
    String? accountId,
    String? cardId,
  });
}
