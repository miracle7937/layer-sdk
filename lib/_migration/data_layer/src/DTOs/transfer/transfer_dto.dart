import '../../helpers.dart';
import '../account_dto.dart';
import '../card_dto.dart';
import '../second_factor_dto.dart';
import 'beneficiary_dto.dart';
import 'bulk_detail_dto.dart';
import 'share_type_dto.dart';
import 'transfer_evaluation_dto.dart';
import 'transfer_recurrence_dto.dart';
import 'transfer_status_dto.dart';
import 'transfer_type_dto.dart';

///Data transfer object representing transfers
class TransferDTO {
  ///The id of the transfer
  int? id;

  ///The source [AccountDTO] object of the transfer
  AccountDTO? fromAccount;

  ///The destination [AccountDTO] object of the transfer
  AccountDTO? toAccount;

  ///The source [CardDTO] object of the transfer
  CardDTO? fromCard;

  ///The destination [CardDTO] object of the transfer
  CardDTO? toCard;

  ///The source mobile number of the transfer
  String? fromMobile;

  ///The destination mobile number of the transfer
  String? toMobile;

  ///The destination [BeneficiaryDTO] object of the transfer
  BeneficiaryDTO? toBeneficiary;

  ///The [TransferTypeDTO] type of the transfer
  TransferTypeDTO? type;

  ///The [ShareTypeDTO] type of the transfer
  ShareTypeDTO? shareType;

  ///The amount of the transfer
  double? amount;

  /// Whether the `amount` should be shown
  bool amountVisible;

  ///The currency of the transfer
  String? currency;

  ///The [TransferStatusDTO] status of the transfer
  TransferStatusDTO? status;

  ///The otp id of the transfer
  int? otpId;

  ///The date the transfer was created on
  DateTime? created;

  ///The last time the transfer was updated
  DateTime? updated;

  ///The future date when the transfer should happen
  DateTime? scheduled;

  ///Whether the transfer is recurring or not
  bool? recurring;

  ///The [TransferRecurrenceDTO] recurrence of the transfer
  TransferRecurrenceDTO? recurrence;

  ///When does the recurring transfer starts on
  DateTime? starts;

  ///When does the recurring transfer ends on
  DateTime? ends;

  ///The charge amount of the transfer
  double? charge;

  ///The charge currency of the transfer
  String? chargeCurrency;

  ///The reference of the transfer
  String? reference;

  ///The reason of the transfer
  String? reason;

  ///The reason id of the transfer
  String? reasonId;

  ///An additional description for the reason
  String? note;

  /// The [SecondFactorDTO] second factor type of the transfer
  SecondFactorDTO? secondFactor;

  ///The [TransferEvaluationDTO] evaluation of the transfer
  TransferEvaluationDTO? evaluation;

  ///The name for the transfer
  String? fullName;

  ///The bulk file path of the transfer
  String? bulkFilePath;

  ///The list of [BulkDetailDTO] of the transfer
  List<BulkDetailDTO>? bulkDetails;

  ///The ribCode of the transfer
  String? ribCode;

  ///Summary information regarding transfer
  Map<String, dynamic>? extra;

  ///Whether the transfer is locked or not
  bool? cbsLocked;

  ///Creates a new [TransferDTO]
  TransferDTO({
    this.id,
    this.fromAccount,
    this.toAccount,
    this.fromCard,
    this.toCard,
    this.fromMobile,
    this.toMobile,
    this.toBeneficiary,
    this.type,
    this.shareType,
    this.amount,
    this.amountVisible = true,
    this.currency,
    this.status,
    this.otpId,
    this.created,
    this.updated,
    this.scheduled,
    this.recurring,
    this.recurrence,
    this.starts,
    this.ends,
    this.charge,
    this.chargeCurrency,
    this.reference,
    this.reason,
    this.reasonId,
    this.note,
    this.secondFactor,
    this.evaluation,
    this.fullName,
    this.bulkFilePath,
    this.bulkDetails,
    this.ribCode,
    this.extra,
    this.cbsLocked,
  });

  /// Creates a [TransferDTO] from a JSON
  factory TransferDTO.fromJson(Map<String, dynamic> json) => TransferDTO(
        id: JsonParser.parseInt(json['transfer_id']),
        fromAccount: json['from_account_id'] == null
            ? null
            : AccountDTO.fromJson(json['from_account']),
        toAccount: json['to_account_id'] == null
            ? null
            : AccountDTO.fromJson(json['to_account']),
        fromCard: json['from_card_id'] == null
            ? null
            : CardDTO.fromJson(json['from_card']),
        toCard: json['to_card_id'] == null
            ? null
            : CardDTO.fromJson(json['to_card']),
        fromMobile: json['from_mobile'],
        toMobile: json['to_mobile'],
        toBeneficiary: json["beneficiary_id"] == null
            ? null
            : BeneficiaryDTO.fromJson(json["beneficiary"]),
        type: TransferTypeDTO.fromRaw(json['trf_type']),
        shareType: ShareTypeDTO.fromRaw(json['share_type']),
        amount: json['amount'] is num
            ? JsonParser.parseDouble(json['amount'])
            : 0.0,
        amountVisible: !(json['amount'] is String &&
            json['amount'].toLowerCase().contains('x')),
        currency: json['currency'],
        status: TransferStatusDTO.fromRaw(json['status']),
        otpId: JsonParser.parseInt(json['otp_id']),
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        scheduled: JsonParser.parseDate(json['ts_scheduled']),
        recurring: json['recurring'] ?? false,
        recurrence: TransferRecurrenceDTO.fromRaw(json['recurrence']),
        starts: JsonParser.parseDate(json['recurrence_start']),
        ends: JsonParser.parseDate(json['recurrence_end']),
        charge: JsonParser.parseDouble(json['charge']),
        chargeCurrency: json['charge_currency'],
        reference: json['reference'],
        reason: json['reason'],
        reasonId: json['reason_id'],
        note: json['note'],
        secondFactor: SecondFactorDTO.fromRaw(json['second_factor']),
        evaluation: TransferEvaluationDTO.fromJson(json['extra'] ?? {}),
        fullName: json['name'],
        bulkFilePath: jsonLookup(json['extra'], ['bulk_file']),
        bulkDetails: json['bulk_transfer_details'] == null
            ? null
            : BulkDetailDTO.fromJsonList(json['bulk_transfer_details']),
        ribCode: json['rib_code'],
        extra: json['extra'] as Map<String, dynamic>,
        cbsLocked: json['locked'] ?? false,
      );

  /// Returns a list of [TransferDTO] from a JSON
  static List<TransferDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(TransferDTO.fromJson).toList();
}
