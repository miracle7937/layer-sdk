import '../../domain_layer/models/banking_product_transaction.dart';
import '../dtos/banking_product_transaction_dto.dart';

/// Extension that provides mapping for [BankingProductTransactionDTO]
extension BankingProductTransactionDTOMapping on BankingProductTransactionDTO {
  /// Maps a [BankingProductTransactionDTO] instance to
  ///  a [BankingProductTransaction] model
  BankingProductTransaction toBankingProductTransaction() =>
      BankingProductTransaction(
        amount: amount,
        currency: currency,
        description: description,
        cardId: cardId,
        accountId: accountId,
        postingDate: postingDate,
        reference: reference,
        transactionId: transactionId?.toString(),
        valueDate: valueDate,
        balance: balance,
        balanceVisible: balanceVisible,
      );
}
