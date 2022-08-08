import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The status a payment can have
enum PaymentStatus {
  /// OTP
  otp,

  /// Expired OTP.
  otpExpired,

  /// Failed
  failed,

  /// Completed
  completed,

  /// Pending
  pending,

  /// Canceled
  cancelled,

  /// Scheduled
  scheduled,

  /// Pending bank
  pendingBank,

  /// Pending expired
  pendingExpired,

  /// Unknown status
  unknown,
}

/// Keeps the data of a payment
class Payment extends Equatable {
  ///The id of the payment
  final int? id;

  ///When the payment was created
  final DateTime? created;

  ///When the payment was updated
  final DateTime? updated;

  ///When the payment was scheduled
  final DateTime? scheduled;

  ///The [Bill] object of the payment
  final Bill? bill;

  /// The source [Account].
  final Account? fromAccount;

  /// The source [BankingCard].
  final BankingCard? fromCard;

  /// The currency of the payment. Or empty if no currency assigned.
  ///
  /// Default to an empty string.
  final String currency;

  /// The amount of the payment.
  final double? amount;

  /// Whether the `amount` should be shown
  final bool amountVisible;

  /// The payment status.
  ///
  /// Defaults to [PaymentStatus.unknown].
  final PaymentStatus status;

  /// Whether the payment is recurring or not
  final bool recurring;

  /// The payment recurrence
  ///
  /// Defaults to [Recurrence.none].
  final Recurrence recurrence;

  /// The recurrence start date of the payment
  final DateTime? recurrenceStart;

  /// The recurrence end date of the payment
  final DateTime? recurrenceEnd;

  /// The if of the one time password
  final int? otpId;

  /// A unique identifier of the payment
  final String? deviceUID;

  /// The second factor type of the payment
  final SecondFactorType? secondFactor;

  ///Creates a new [Payment] object
  const Payment({
    this.id,
    this.created,
    this.updated,
    this.scheduled,
    this.bill,
    this.fromAccount,
    this.fromCard,
    this.currency = '',
    this.amount,
    this.amountVisible = true,
    this.status = PaymentStatus.unknown,
    this.recurrence = Recurrence.none,
    this.recurrenceStart,
    this.recurrenceEnd,
    this.otpId,
    this.deviceUID,
    this.secondFactor,
    this.recurring = false,
  });

  ///Payment id toString()
  @Deprecated('Will be removed in the future. Access id and cast if needed')
  String? get paymentId => id?.toString();

  ///String consisting on the currency and the amount
  @Deprecated('Will be removed in the future. Format on the UI.')
  String get currencyAndAmount => '$currency $amount';

  @override
  List<Object?> get props => [
        id,
        created,
        updated,
        scheduled,
        bill,
        fromAccount,
        fromCard,
        currency,
        amount,
        amountVisible,
        status,
        recurrence,
        recurrenceStart,
        recurrenceEnd,
        otpId,
        deviceUID,
        secondFactor,
        recurring,
      ];

  ///Clone and return a new [Payment] object
  Payment copyWith({
    int? id,
    DateTime? created,
    DateTime? updated,
    DateTime? scheduled,
    Bill? bill,
    Account? fromAccount,
    BankingCard? fromCard,
    String? currency,
    double? amount,
    bool? amountVisible,
    PaymentStatus? status,
    Recurrence? recurrence,
    DateTime? recurrenceStart,
    DateTime? recurrenceEnd,
    int? otpId,
    String? deviceUID,
    SecondFactorType? secondFactor,
    bool? recurring,
  }) {
    return Payment(
      id: id ?? this.id,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      scheduled: scheduled ?? this.scheduled,
      bill: bill ?? this.bill,
      fromAccount: fromAccount ?? this.fromAccount,
      fromCard: fromCard ?? this.fromCard,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      amountVisible: amountVisible ?? this.amountVisible,
      status: status ?? this.status,
      recurrence: recurrence ?? this.recurrence,
      recurrenceStart: recurrenceStart ?? this.recurrenceStart,
      recurrenceEnd: recurrenceEnd ?? this.recurrenceEnd,
      otpId: otpId ?? this.otpId,
      deviceUID: deviceUID ?? this.deviceUID,
      secondFactor: secondFactor ?? this.secondFactor,
      recurring: recurring ?? this.recurring,
    );
  }
}
