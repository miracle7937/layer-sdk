import 'package:equatable/equatable.dart';

/// BankingProduct Transaction data used by the application
class BankingProductTransaction extends Equatable {
  /// BankingProduct transaction unique identifier
  final String? transactionId;

  /// Card on which transaction was made: if on account then it's sent as null
  final String? cardId;

  /// Account on which transaction was made: if on card then it's sent as null
  final String? accountId;

  /// Transaction description
  final String? description;

  /// Transaction reference
  final String? reference;

  /// Date that the transaction was made
  final DateTime? valueDate;

  /// Date that the transaction payment was made
  final DateTime? postingDate;

  /// Currency used in the transaction
  final String? currency;

  /// Amount used in this transaction
  /// Can be negative or positive
  final num? amount;

  /// BankingProduct balance after the transaction
  final num? balance;

  /// Whether the `amount` and `balance` should be shown
  final bool balanceVisible;

  /// Creates a new immutable instance of [BankingProductTransaction]
  BankingProductTransaction({
    this.transactionId,
    this.cardId,
    this.accountId,
    this.description,
    this.reference,
    this.valueDate,
    this.postingDate,
    this.currency,
    this.amount,
    this.balance,
    this.balanceVisible = true,
  });

  @override
  List<Object?> get props => [
        transactionId,
        cardId,
        accountId,
        description,
        reference,
        valueDate,
        postingDate,
        currency,
        amount,
        balance,
        balanceVisible,
      ];
}
