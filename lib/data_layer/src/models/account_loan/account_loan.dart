import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// A model representing an account loan.
class AccountLoan extends Equatable {
  /// The loan identifier.
  final String? id;

  /// The loan name.
  final String? name;

  /// The total amount of the loan.
  final double totalAmount;

  /// The total amount repaid.
  final double amountRepaid;

  /// The total amount remaining.
  final double amountRemaining;

  /// The amount to be paid in the next payment.
  final double nextPaymentAmount;

  /// The date the next payment is due.
  final DateTime? nextPaymentDate;

  /// The due date of the entire loan.
  final DateTime? maturityDate;

  /// The creation date of the loan.
  final DateTime? createdDate;

  /// The count of total loan payments.
  final int totalPayments;

  /// The count of payments paid.
  final int paidPayments;

  /// The payments for this loan.
  ///
  /// This field will be empty if the loan details are not fetched.
  final UnmodifiableListView<AccountLoanPayment> payments;

  /// Creates [AccountLoan].
  AccountLoan({
    this.id,
    this.name,
    required this.totalAmount,
    required this.amountRepaid,
    required this.amountRemaining,
    required this.nextPaymentAmount,
    this.nextPaymentDate,
    this.maturityDate,
    this.createdDate,
    required this.totalPayments,
    required this.paidPayments,
    Iterable<AccountLoanPayment>? payments,
  }) : payments = UnmodifiableListView(payments ?? []);

  @override
  List<Object?> get props => [
        id,
        name,
        totalAmount,
        amountRepaid,
        amountRemaining,
        nextPaymentAmount,
        nextPaymentDate,
        maturityDate,
        createdDate,
        totalPayments,
        paidPayments,
        payments,
      ];
}
