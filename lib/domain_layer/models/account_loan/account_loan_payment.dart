import 'package:equatable/equatable.dart';

/// The status of the loan payment.
enum AccountLoanPaymentStatus {
  /// The payment was paid.
  paid,

  /// The payment was not paid.
  unpaid,
}

/// A model representing the account loan payment.
class AccountLoanPayment extends Equatable {
  /// The payment identifier.
  final String? id;

  /// The payment status.
  final AccountLoanPaymentStatus? status;

  /// The payment amount.
  final double? amount;

  /// The amount of the fees.
  final double? fees;

  /// The payment currency.
  final String? currency;

  /// The fees currency.
  final String? feesCurrency;

  /// The number used to identify the payment by the customer.
  final int? serial;

  /// The date when the payment is due.
  final DateTime? dueDate;

  /// Creates [AccountLoanPayment].
  AccountLoanPayment({
    this.id,
    this.status,
    this.amount,
    this.fees,
    this.currency,
    this.feesCurrency,
    this.serial,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        amount,
        fees,
        currency,
        feesCurrency,
        serial,
        dueDate,
      ];
}
