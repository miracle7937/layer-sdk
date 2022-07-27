import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The recurrence a payment can have
enum Recurrence {
  /// No recurrence
  none,

  /// Once
  once,

  /// Daily
  daily,

  /// Weekly
  weekly,

  /// Bi-weekly
  biweekly,

  /// Monthly
  monthly,

  /// Bi-monthly
  bimonthly,

  /// Quarterly
  quarterly,

  /// Yearly
  yearly,

  /// End of each month
  endOfEachMonth,
}

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
      ];
}
