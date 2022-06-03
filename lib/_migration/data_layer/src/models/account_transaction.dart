import 'package:equatable/equatable.dart';

/// Account Transaction data used by the application
class AccountTransaction extends Equatable {
  /// Account transaction unique identifier
  final String? transactionId;

  /// Transaction description
  final String? description;

  /// This is a placeholder until the BE returns us
  /// with the location of the transaction
  // TODO(VF): Correct this once we have the data
  final String? location;

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

  /// Account balance after the transaction
  final num? balance;

  /// Whether the `amount` and `balance` should be shown
  final bool balanceVisible;

  /// Creates a new immutable instance of [AccountTransaction]
  AccountTransaction({
    this.transactionId,
    this.description,
    this.location,
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
        description,
        location,
        reference,
        valueDate,
        postingDate,
        currency,
        amount,
        balance,
        balanceVisible,
      ];
}
