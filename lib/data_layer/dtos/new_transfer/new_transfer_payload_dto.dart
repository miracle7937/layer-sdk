import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing the payload to send to the API
/// when performing a new transfer flow.
class NewTransferPayloadDTO {
  /// The transfer id. Used for editing transfers.
  int? transferId;

  /// The transfer type.
  TransferTypeDTO type;

  /// The source account id.
  String? fromAccountId;

  /// The source card id.
  int? fromCardId;

  /// The source wallet id.
  int? fromWalletId;

  /// The source mobile number.
  String? fromMobile;

  /// The source provider.
  String? fromProvider;

  /// The amount for the transfer.
  double amount;

  /// The curency code;
  String currencyCode;

  /// The reason.
  String? reason;

  /// The note.
  String? note;

  /// The extra data for the transfer.
  Map<String, dynamic>? extra;

  /// Whether if the transfer is locker or not.
  bool? locked;

  /// The destination account id.
  String? toAccountId;

  /// The destination card id.
  int? toCardId;

  /// The destination benenficiary id.
  int? toBeneficiaryId;

  /// The new benenficiary object.
  BeneficiaryDTO? newBeneficiary;

  /// The destination mobile number.
  String? toMobile;

  /// The destination provider.
  String? toProvider;

  /// The ransfer recurrence.
  TransferRecurrenceDTO? recurrence;

  /// The start date.
  DateTime? startDate;

  /// The end date.
  DateTime? endDate;

  /// The transfer processing type.
  TransferProcessingTypeDTO? processingType;

  /// Creates a new [NewTransferPayloadDTO].
  NewTransferPayloadDTO({
    required this.type,
    this.transferId,
    this.fromAccountId,
    this.fromCardId,
    this.fromWalletId,
    this.fromMobile,
    this.fromProvider,
    required this.amount,
    required this.currencyCode,
    this.reason,
    this.note,
    this.extra,
    this.locked,
    this.toAccountId,
    this.toCardId,
    this.toBeneficiaryId,
    this.newBeneficiary,
    this.toMobile,
    this.toProvider,
    this.recurrence,
    this.startDate,
    this.endDate,
    this.processingType,
  });

  /// Returns a json map with the provided values.
  Map<String, dynamic> toJson() {
    var extra = this.extra;

    return {
      if (transferId != null) 'transfer_id': transferId,
      'trf_type': type.value,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (fromCardId != null) 'from_card_id': fromCardId,
      if (fromWalletId != null) 'from_wallet_id': fromWalletId,
      if (fromMobile != null) 'from_mobile': fromMobile,
      if (fromProvider != null) 'from_provider': fromProvider,
      'amount': amount,
      'currency': currencyCode,
      'device_uid': randomAlphaNumeric(32),
      if (note != null) 'note': note,
      if (reason != null) 'reason': reason,
      if (extra != null) 'extra': extra,
      if (locked != null) 'locked': locked,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (toCardId != null) 'to_card_id': toCardId,
      if (toBeneficiaryId != null) 'beneficiary_id': toBeneficiaryId,
      if (newBeneficiary != null) 'beneficiary': newBeneficiary!.toJson(),
      if (recurrence != null && startDate != null) ...{
        if (recurrence == TransferRecurrenceDTO.once) ...{
          'ts_scheduled': startDate!.millisecondsSinceEpoch,
        } else ...{
          'recurring': true,
          'recurrence': recurrence!.value,
          'recurrence_start': startDate!.millisecondsSinceEpoch,
          if (endDate != null)
            'recurrence_end': endDate!.millisecondsSinceEpoch,
        }
      },
      if (processingType != null) 'processing_type': processingType!.value,
    };
  }
}
