import '../../dtos.dart';
import '../../helpers.dart';

/// Represents customer checkbook object
class CheckbookDTO {
  /// Checkbook ID
  int? id;

  /// The date the checkbook was created
  DateTime? created;

  /// The date the checkbook was updated
  DateTime? updated;

  /// The checkbook type ID
  String? checkbookTypeId;

  /// The checkbook type
  CheckbookTypeDTO? checkbookType;

  /// The account ID for which this checkbook was created
  String? accountId;

  /// The account for which this checkbook was created
  AccountDTO? account;

  /// The charge amount
  int? chargeAmount;

  /// The charge currency
  String? chargeCurrency;

  /// The reference
  String? reference;

  /// The system notes
  String? systemNotes;

  /// The customer id this checkbook belongs to
  String? customerId;

  /// The username this checkbook belongs to
  String? username;

  /// The checkbook status
  String? status;

  /// Creates a new [CheckbookDTO]
  CheckbookDTO({
    this.id,
    this.created,
    this.updated,
    this.checkbookTypeId,
    this.checkbookType,
    this.accountId,
    this.account,
    this.chargeAmount,
    this.chargeCurrency,
    this.reference,
    this.systemNotes,
    this.customerId,
    this.username,
    this.status,
  });

  /// Creates a [CheckbookDTO] from a JSON
  factory CheckbookDTO.fromJson(Map<String, dynamic> json) => CheckbookDTO(
        id: json['checkbook_id'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        checkbookTypeId: json['checkbook_type_id'],
        checkbookType: CheckbookTypeDTO.fromJson(json['checkbook_type']),
        accountId: json['account_id'],
        account: AccountDTO.fromJson(json['account']),
        chargeAmount: json['charge_amount'],
        chargeCurrency: json['charge_currency'],
        reference: json['reference'],
        systemNotes: json['system_notes'],
        customerId: json['customer_id'],
        username: json['username'],
        status: json['status'],
      );

  /// Creates a list of [CheckbookDTO] from a List
  static List<CheckbookDTO> fromJsonList(List<Map<String, dynamic>> list) =>
      list.map(CheckbookDTO.fromJson).toList(growable: false);
}

/// Represents Checkbook Type object
class CheckbookTypeDTO {
  /// The checkbook type ID
  String? checkbookTypeId;

  /// The date the checkbook type was created
  DateTime? created;

  /// The date the checkbook type was updated
  DateTime? updated;

  /// The number of leaves
  int? leaves;

  /// The start date
  DateTime? start;

  /// The end date
  DateTime? end;

  /// The maximum number of checkbooks per request
  int? maxCheckbooks;

  /// The maximum number of checkbooks pending delivery
  int? maxPending;

  /// The fees
  int? fees;

  /// Creates a new [CheckbookTypeDTO]
  CheckbookTypeDTO({
    this.checkbookTypeId,
    this.created,
    this.updated,
    this.leaves,
    this.start,
    this.end,
    this.maxCheckbooks,
    this.maxPending,
    this.fees,
  });

  /// Creates a [CheckbookTypeDTO] from a JSON
  factory CheckbookTypeDTO.fromJson(Map<String, dynamic> json) =>
      CheckbookTypeDTO(
        checkbookTypeId: json['checkbook_type_id'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        leaves: json['leaves'],
        start: JsonParser.parseDate(json['ts_start']),
        end: JsonParser.parseDate(json['ts_end']),
        maxCheckbooks: json['max_checkbooks'],
        maxPending: json['max_pending'],
        fees: json['fees'],
      );
}
