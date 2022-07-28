import 'package:equatable/equatable.dart';

/// Class that stores data for Mandates payments
class MandatePayment extends Equatable {
  /// The payment id
  /// 0 = with no data returned from server
  final int paymentId;

  /// The mandateId
  /// 0 = with no data returned from server
  final int mandateId;

  /// The payment status
  final MandatePaymentStatus status;

  /// The payment currency
  final String currency;

  /// The payment amount
  final double amount;

  /// The payment reference
  final String reference;

  /// The payment id on the bank
  final String bankPaymentId;

  /// When it was created
  final DateTime? tsCreated;

  /// When it was updates
  final DateTime? tsUpdated;

  /// Creates a new [MandatePayment] instance
  MandatePayment({
    this.paymentId = 0,
    this.mandateId = 0,
    this.bankPaymentId = '',
    this.status = MandatePaymentStatus.unknown,
    this.amount = 0.0,
    this.reference = '',
    this.currency = '',
    this.tsCreated,
    this.tsUpdated,
  });

  @override
  List<Object?> get props {
    return [
      paymentId,
      mandateId,
      currency,
      amount,
      reference,
      bankPaymentId,
      tsCreated,
      tsUpdated,
    ];
  }

  /// Creates a copy of [MandatePayment]
  MandatePayment copyWith({
    int? paymentId,
    int? mandateId,
    String? currency,
    double? amount,
    String? reference,
    String? bankPaymentId,
    DateTime? tsCreated,
    DateTime? tsUpdated,
  }) {
    return MandatePayment(
      paymentId: paymentId ?? this.paymentId,
      mandateId: mandateId ?? this.mandateId,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
      bankPaymentId: bankPaymentId ?? this.bankPaymentId,
      tsCreated: tsCreated ?? this.tsCreated,
      tsUpdated: tsUpdated ?? this.tsUpdated,
    );
  }
}

/// Enum that holds a [MandatePayment] status
enum MandatePaymentStatus {
  /// Payment with status active
  active,

  /// Payment with status returning
  returning,

  /// Payment with status accepted
  accepted,

  /// Payment with status pending
  pending,

  /// Payment with status declined
  declined,

  /// Payment with status unknown
  unknown,
}
