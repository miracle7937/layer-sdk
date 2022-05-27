import 'package:collection/collection.dart';
import '../../helpers.dart';

/// DTO used to used for parsing Loyalty data
class LoyaltyDTO {
  /// Loyalty ID
  final int? loyaltyId;

  /// When it was created
  final DateTime? created;

  /// Last time it was updated
  final DateTime? updated;

  /// Loyalty Status
  final LoyaltyStatusDTO? status;

  /// Available balance points
  final int? balance;

  /// Available earned points
  final int? earned;

  /// The amount of points that a user has spent
  final int? burned;

  /// Available transferred loyalty points
  final int? transferred;

  /// Adjusted loyalty points
  final int? adjusted;

  /// Date of the Last transaction
  final DateTime? lastTxn;

  /// Creates a new [LoyaltyDTO] object
  LoyaltyDTO({
    this.loyaltyId,
    this.created,
    this.updated,
    this.balance,
    this.status,
    this.earned,
    this.burned,
    this.transferred,
    this.adjusted,
    this.lastTxn,
  });

  /// Creates a [LoyaltyDTO] form a JSON object
  factory LoyaltyDTO.fromJson(Map<String, dynamic> json) {
    return LoyaltyDTO(
      loyaltyId: JsonParser.parseInt(json['loyalty_id']),
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      status: LoyaltyStatusDTO.fromRaw(json['status']),
      balance: JsonParser.parseInt(json['balance']),
      earned: JsonParser.parseInt(json['earned']),
      burned: JsonParser.parseInt(json['burned']),
      transferred: JsonParser.parseInt(json['transfered']),
      adjusted: JsonParser.parseInt(json['adjusted']),
      lastTxn: JsonParser.parseDate(json['last_txn']),
    );
  }

  /// Return a list of [LoyaltyDTO] from a json list
  static List<LoyaltyDTO> fromJsonList(List json) {
    return json.map((l) => LoyaltyDTO.fromJson(l)).toList();
  }
}

/// Maps Loyalty Status
class LoyaltyStatusDTO extends EnumDTO {
  const LoyaltyStatusDTO._internal(String value) : super.internal(value);

  /// Loyalty active
  static const active = LoyaltyStatusDTO._internal('A');

  /// Loyalty deleted
  static const deleted = LoyaltyStatusDTO._internal('D');

  /// List all possible status
  static const List<LoyaltyStatusDTO> values = [
    active,
    deleted,
  ];

  /// Parse a string to its respective status
  static LoyaltyStatusDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (it) => it.value == raw,
      );
}
