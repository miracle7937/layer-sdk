import 'package:equatable/equatable.dart';

import '../../models.dart';

///The status of the transfer
enum TransferStatus {
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

///The type of the transfer
enum TransferType {
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

///The transfer processing type.
enum TransferProcessingType {
  ///Instant.
  instant,

  ///Next day.
  nextDay,
}

///The transfer data used by the application
class Transfer extends Equatable {
  /// The transfer id.
  final int? id;

  /// The currency used in this transfer.
  final String? currency;

  /// The amount of the transfer.
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

  /// The transfer recurrence.
  final Recurrence recurrence;

  /// The transfer creation date.
  final DateTime? created;

  /// The transfer status.
  final TransferStatus? status;

  /// The transfer type.
  final TransferType? type;

  ///The future date when the transfer should happen
  final DateTime? scheduledDate;

  /// The processing type.
  final TransferProcessingType? processingType;

  ///Creates a new immutable [Transfer]
  Transfer({
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
    this.recurrence = Recurrence.none,
    this.created,
    this.status,
    this.type,
    this.scheduledDate,
    this.processingType,
  });

  /// Returns the transfer id as `String`.
  String? get transferId => id?.toString();

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
        processingType,
      ];
}
