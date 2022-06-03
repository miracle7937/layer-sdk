import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mapping for [AccountTransactionDTO]
extension AccountTransactionDTOMapping on AccountTransactionDTO {
  /// Maps a [AccountTransactionDTO] instance to a [AccountTransaction] model
  AccountTransaction toAccountTransaction() => AccountTransaction(
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
