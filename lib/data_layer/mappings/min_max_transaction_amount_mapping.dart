import '../../domain_layer/models/min_max_transaction_amount.dart';
import '../dtos/min_max_transaction_amount_dto.dart';

/// Extension that provides mapping for [MinMaxTransactionAmountDTO]
extension MinMaxTransactionAmountDTOMapping on MinMaxTransactionAmountDTO {
  /// Maps a [MinMaxTransactionAmountDTO] instance to
  ///  a [MinMaxTransactionAmount] model
  MinMaxTransactionAmount toMinMaxTransactionAmount() =>
      MinMaxTransactionAmount(
        minAmount: minAmount,
        maxAmount: maxAmount,
        currencies: currencies,
      );
}
