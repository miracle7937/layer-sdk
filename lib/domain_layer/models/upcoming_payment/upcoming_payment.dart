import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';
import '../../../_migration/data_layer/models.dart';

/// The status an upcoming payment can have
enum UpcomingPaymentStatus {
  /// Paid
  paid,

  /// Unpaid
  unpaid,
}

/// The type of an upcoming payment
enum UpcomingPaymentType {
  /// Account loan instalment.
  accountLoan,

  /// Bill
  bill,

  /// Recurring transfer
  recurringTransfer,

  /// Finance account
  financeAccount,

  /// Credit card
  creditCard,

  /// Goal
  goal,

  /// Recurring payment
  recurringPayment,
}

/// Keeps the data of an upcoming payment
class UpcomingPayment extends Equatable {
  /// The id of the payment
  final String? id;

  ///The merchant name
  final String? merchantName;

  ///The date the payment should complete
  final DateTime? date;

  ///The amount of the payment
  final double? amount;

  ///The currency of the payment
  final String? currency;

  ///The status of the payment
  final UpcomingPaymentStatus? status;

  ///The amount of payments for the loan
  final int? totalPayments;

  ///The order this payment has in the loan's payments
  final int? currentPayment;

  /// Payment nickname
  final String? nickname;

  /// Payment name
  final String? name;

  /// Payment recurrence
  final String? recurrence;

  /// Payment date
  final DateTime? dateTime;

  /// Payment number
  final String? number;

  /// Payment type
  final UpcomingPaymentType? paymentType;

  /// Payment transfer
  final Transfer? transfer;

  /// Payment bill
  final Bill? bill;

  /// Payment is name localized
  final bool? isNameLocalized;

  ///Creates a new [UpcomingPayment]
  UpcomingPayment({
    this.id,
    this.nickname,
    this.name,
    this.recurrence,
    this.dateTime,
    this.number,
    this.paymentType,
    this.transfer,
    this.bill,
    this.isNameLocalized,
    this.merchantName,
    this.date,
    this.amount,
    this.currency,
    this.status,
    this.totalPayments,
    this.currentPayment,
  });

  /// Creates a copy of this upcoming payment with different values
  UpcomingPayment copyWith({
    String? id,
    String? merchantName,
    DateTime? date,
    double? amount,
    String? currency,
    UpcomingPaymentStatus? status,
    int? totalPayments,
    int? currentPayment,
    String? nickname,
    String? name,
    String? recurrence,
    DateTime? dateTime,
    String? number,
    UpcomingPaymentType? paymentType,
    Transfer? transfer,
    Bill? bill,
    bool? isNameLocalized,
  }) =>
      UpcomingPayment(
        id: id ?? this.id,
        merchantName: merchantName ?? this.merchantName,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        totalPayments: totalPayments ?? this.totalPayments,
        currentPayment: currentPayment ?? this.currentPayment,
        nickname: nickname ?? this.nickname,
        name: name ?? this.name,
        recurrence: recurrence ?? this.recurrence,
        dateTime: dateTime ?? this.dateTime,
        number: number ?? this.number,
        paymentType: paymentType ?? this.paymentType,
        transfer: transfer ?? this.transfer,
        bill: bill ?? this.bill,
        isNameLocalized: isNameLocalized ?? this.isNameLocalized,
      );

  @override
  List<Object?> get props => [
        id,
        merchantName,
        date,
        amount,
        currency,
        status,
        totalPayments,
        currency,
        nickname,
        name,
        recurrence,
        dateTime,
        number,
        paymentType,
        transfer,
        bill,
        isNameLocalized,
      ];

  /// Title getter
  String get title => nickname ?? name ?? '';
}
