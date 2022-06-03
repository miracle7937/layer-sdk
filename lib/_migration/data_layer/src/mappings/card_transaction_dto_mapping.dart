import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mapping for [CardTransactionDTO]
extension CardTransactionDTOMapping on CardTransactionDTO {
  /// Maps a [CardTransactionDTO] instance to a [CardTransaction] model
  CardTransaction toCardTransaction() => CardTransaction(
        amount: amount,
        currency: currency,
        description: description,
        location: location,
        postingDate: postingDate,
        reference: reference,
        transactionId: transactionId?.toString(),
        valueDate: valueDate,
        balance: balance,
        balanceVisible: balanceVisible,
      );
}
