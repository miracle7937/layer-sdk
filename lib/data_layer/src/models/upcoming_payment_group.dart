import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'upcoming_payment.dart';

/// Keeps the data of an upcoming payment
class UpcomingPaymentGroup extends Equatable {
  /// Account loan payments
  final UnmodifiableListView<UpcomingPayment> accountLoanPayments;

  /// Bill payments
  final UnmodifiableListView<UpcomingPayment> billPayments;

  /// Credit card payments
  final UnmodifiableListView<UpcomingPayment> creditCardPayments;

  /// Scheduled transfer payments
  final UnmodifiableListView<UpcomingPayment> scheduledTransferPayments;

  /// Goal payments
  final UnmodifiableListView<UpcomingPayment> goalPayments;

  /// All payments
  final UnmodifiableListView<UpcomingPayment> allPayments;

  /// Scheduled payments
  final UnmodifiableListView<UpcomingPayment> scheduledPayments;

  /// Account loan dues
  final double? accountLoanDues;

  /// Bill dues
  final double? billDues;

  /// Credit card dues
  final double? creditCardDues;

  /// Schedules transfer dues
  final double? scheduledTransferDues;

  /// Goal dues
  final double? goalDues;

  /// Schedule payments dues
  final double? scheduledPaymentsDues;

  /// Total
  final double? total;

  /// Pref currency
  final String? prefCurrency;

  /// Whether or not the values of this [UpcomingPaymentGroup] should be hidden.
  final bool hideValues;

  ///Creates a new [UpcomingPaymentGroup]
  UpcomingPaymentGroup({
    Iterable<UpcomingPayment>? accountLoanPayments,
    Iterable<UpcomingPayment>? billPayments,
    Iterable<UpcomingPayment>? creditCardPayments,
    Iterable<UpcomingPayment>? scheduledTransferPayments,
    Iterable<UpcomingPayment>? goalPayments,
    Iterable<UpcomingPayment>? allPayments,
    Iterable<UpcomingPayment>? scheduledPayments,
    this.accountLoanDues,
    this.billDues,
    this.creditCardDues,
    this.scheduledTransferDues,
    this.goalDues,
    this.scheduledPaymentsDues,
    this.total,
    this.prefCurrency,
    this.hideValues = false,
  })  : accountLoanPayments = UnmodifiableListView(accountLoanPayments ?? []),
        billPayments = UnmodifiableListView(billPayments ?? []),
        creditCardPayments = UnmodifiableListView(creditCardPayments ?? []),
        goalPayments = UnmodifiableListView(goalPayments ?? []),
        allPayments = UnmodifiableListView(allPayments ?? []),
        scheduledPayments = UnmodifiableListView(scheduledPayments ?? []),
        scheduledTransferPayments =
            UnmodifiableListView(scheduledTransferPayments ?? []);

  /// Creates a copy of this upcoming payment with different values
  UpcomingPaymentGroup copyWith({
    Iterable<UpcomingPayment>? accountLoanPayments,
    Iterable<UpcomingPayment>? billPayments,
    Iterable<UpcomingPayment>? creditCardPayments,
    Iterable<UpcomingPayment>? scheduledTransferPayments,
    Iterable<UpcomingPayment>? goalPayments,
    Iterable<UpcomingPayment>? allPayments,
    Iterable<UpcomingPayment>? scheduledPayments,
    double? accountLoanDues,
    double? billDues,
    double? creditCardDues,
    double? scheduledTransferDues,
    double? goalDues,
    double? scheduledPaymentsDues,
    double? total,
    String? prefCurrency,
    bool? hideValues,
  }) =>
      UpcomingPaymentGroup(
        accountLoanPayments: accountLoanPayments ?? this.accountLoanPayments,
        billPayments: billPayments ?? this.billPayments,
        creditCardPayments: creditCardPayments ?? this.creditCardPayments,
        scheduledTransferPayments:
            scheduledTransferPayments ?? this.scheduledTransferPayments,
        goalPayments: goalPayments ?? this.goalPayments,
        allPayments: allPayments ?? this.allPayments,
        scheduledPayments: scheduledPayments ?? this.scheduledPayments,
        accountLoanDues: accountLoanDues ?? this.accountLoanDues,
        creditCardDues: creditCardDues ?? this.creditCardDues,
        billDues: billDues ?? this.billDues,
        scheduledTransferDues:
            scheduledTransferDues ?? this.scheduledTransferDues,
        goalDues: goalDues ?? this.goalDues,
        scheduledPaymentsDues:
            scheduledPaymentsDues ?? this.scheduledPaymentsDues,
        total: total ?? this.total,
        prefCurrency: prefCurrency ?? this.prefCurrency,
        hideValues: hideValues ?? this.hideValues,
      );

  @override
  List<Object?> get props => [
        accountLoanPayments,
        billPayments,
        creditCardPayments,
        scheduledTransferPayments,
        goalPayments,
        allPayments,
        scheduledPayments,
        accountLoanDues,
        creditCardDues,
        billDues,
        scheduledTransferDues,
        goalDues,
        scheduledPaymentsDues,
        total,
        prefCurrency,
        hideValues,
      ];

  /// Returns all payments
  Iterable<UpcomingPayment> get getAllPayments => allPayments;
}
