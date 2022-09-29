import 'package:collection/collection.dart';

import '../../../helpers.dart';

/// DTO used to used for parsing Loyalty points data
class LoyaltyPointsDTO {
  /// Loyalty ID
  final int? loyaltyId;

  /// When it was created
  final DateTime? created;

  /// Last time it was updated
  final DateTime? updated;

  /// Loyalty points status
  final LoyaltyPointsStatusDTO? status;

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

  /// Creates a new [LoyaltyPointsDTO] object
  LoyaltyPointsDTO({
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

  /// Creates a [LoyaltyPointsDTO] form a JSON object
  factory LoyaltyPointsDTO.fromJson(Map<String, dynamic> json) =>
      LoyaltyPointsDTO(
        loyaltyId: JsonParser.parseInt(json['loyalty_id']),
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        status: LoyaltyPointsStatusDTO.fromRaw(json['status']),
        balance: JsonParser.parseInt(json['balance']),
        earned: JsonParser.parseInt(json['earned']),
        burned: JsonParser.parseInt(json['burned']),
        transferred: JsonParser.parseInt(json['transfered']),
        adjusted: JsonParser.parseInt(json['adjusted']),
        lastTxn: JsonParser.parseDate(json['last_txn']),
      );

  /// Return a list of [LoyaltyPointsDTO] from a json list
  static List<LoyaltyPointsDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(LoyaltyPointsDTO.fromJson).toList();
}

/// Maps Loyalty points Status
class LoyaltyPointsStatusDTO extends EnumDTO {
  const LoyaltyPointsStatusDTO._internal(String value) : super.internal(value);

  /// Loyalty points active
  static const active = LoyaltyPointsStatusDTO._internal('A');

  /// Loyalty points deleted
  static const deleted = LoyaltyPointsStatusDTO._internal('D');

  /// List all possible status
  static const List<LoyaltyPointsStatusDTO> values = [
    active,
    deleted,
  ];

  /// Parse a string to its respective status
  static LoyaltyPointsStatusDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull((it) => it.value == raw);
}
