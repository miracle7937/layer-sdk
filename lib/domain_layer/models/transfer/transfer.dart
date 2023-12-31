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
  ///
  /// Defaults to `true`
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

  ///The bulk file path of the transfer
  final String bulkFilePath;

  /// The processing type.
  final TransferProcessingType? processingType;

  /// The second factor type.
  final SecondFactorType? secondFactorType;

  /// The transfer evaluation.
  final TransferEvaluation? evaluation;

  /// The OTP id.
  final int? otpId;

  /// The recurrence start date.
  final DateTime? starts;

  /// The recurrence end date.
  final DateTime? ends;

  /// Device UID
  final String? deviceUID;

  ///The reason of the transfer
  final String? reason;

  ///An additional description for the reason
  final String? note;

  ///Creates a new immutable [Transfer]
  const Transfer({
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
    this.bulkFilePath = '',
    this.processingType,
    this.secondFactorType,
    this.evaluation,
    this.otpId,
    this.starts,
    this.ends,
    this.deviceUID,
    this.reason,
    this.note,
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
        bulkFilePath,
        processingType,
        secondFactorType,
        evaluation,
        otpId,
        starts,
        ends,
        deviceUID,
        reason,
        note,
      ];
}
