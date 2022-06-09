import 'package:equatable/equatable.dart';

import '../../../_migration/data_layer/src/models/banking_card.dart';
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

  ///Creates a new [Payment] object
  const Payment({
    this.id,
    this.created,
    this.scheduled,
    this.bill,
    this.fromAccount,
    this.fromCard,
    this.currency = '',
    this.amount,
    this.amountVisible = true,
    this.status = PaymentStatus.unknown,
    this.recurrence = Recurrence.none,
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
        scheduled,
        bill,
        fromAccount,
        fromCard,
        currency,
        amount,
        amountVisible,
        status,
        recurrence,
      ];
}
