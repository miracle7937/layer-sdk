import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

///The recurrence of the standing order
enum StandingOrderRecurrence {
  ///once
  once,

  ///daily
  daily,

  ///weekly
  weekly,

  ///biweekly
  biweekly,

  ///monthly
  monthly,

  ///bimonthly
  bimonthly,

  ///quarterly
  quarterly,

  ///yearly
  yearly,

  ///endOfEachMonth
  endOfEachMonth,

  ///none
  none,
}

///The status of the standing order
enum StandingOrderStatus {
  ///Completed
  completed,

  ///Pending
  pending,

  ///Scheduled
  scheduled,

  ///Failed
  failed,

  ///Canceled
  cancelled,

  ///Rejected
  rejected,

  ///Pending expired
  pendingExpired,

  ///OTP
  otp,

  ///OTP Expired
  otpExpired,

  /// Deleted
  deleted,
}

///The type of the standing order
enum StandingOrderType {
  ///Own
  own,

  ///Bank
  bank,

  ///Domestic
  domestic,

  ///International
  international,

  ///Bulk
  bulk,

  ///Instant
  instant,

  ///Cash in
  cashIn,

  ///Cash out
  cashOut,

  ///Mobile to beneficiary
  mobileToBeneficiary,

  ///Merchant transfer
  merchantTransfer,
}

///The standing order data used by the application
class StandingOrder extends Equatable {
  /// The standing order id.
  final int? id;

  /// The currency used in this standing order.
  final String? currency;

  /// The amount of the standing order.
  final double? amount;

  /// Whether the `amount` should be shown
  final bool amountVisible;

  /// The source [Account].
  final Account? fromAccount;

  /// The destination [Account].
  final Account? toAccount;

  /// The source [BankingCard].
  final BankingCard? fromCard;

  /// The destination [BankingCard].
  final BankingCard? toCard;

  /// The source mobile number.
  final String? fromMobile;

  /// The destination mobile number.
  final String? toMobile;

  /// The destination [Beneficiary].
  final Beneficiary? toBeneficiary;

  /// The standing order recurrence.
  final StandingOrderRecurrence recurrence;

  /// The standing order creation date.
  final DateTime? created;

  /// The standing order status.
  final StandingOrderStatus? status;

  /// The standing order type.
  final StandingOrderType? type;

  ///The future date when the standing order should happen
  final DateTime? scheduledDate;

  ///Creates a new immutable [StandingOrder]
  StandingOrder({
    this.id,
    this.currency,
    this.amount,
    this.amountVisible = true,
    this.fromAccount,
    this.toAccount,
    this.fromCard,
    this.toCard,
    this.fromMobile,
    this.toMobile,
    this.toBeneficiary,
    this.recurrence = StandingOrderRecurrence.none,
    this.created,
    this.status,
    this.type,
    this.scheduledDate,
  });

  @override
  List<Object?> get props => [
        id,
        currency,
        amount,
        amountVisible,
        fromAccount,
        toAccount,
        fromCard,
        toCard,
        fromMobile,
        toMobile,
        toBeneficiary,
        recurrence,
        created,
        status,
        type,
        scheduledDate,
      ];
}
