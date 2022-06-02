import 'package:collection/collection.dart';

import '../../../helpers.dart';

/// DTO used to used for parsing Loyalty points transfers data
class LoyaltyPointsTransactionDTO {
  /// Transaction ID
  final String? transactionID;

  /// When the transaction was created
  final DateTime? created;

  /// When the transaction was updated
  final DateTime? updated;

  /// Transaction type
  final LoyaltyPointsTransactionTypeDTO? transactionType;

  /// ID of the Loyalty
  final int? loyaltyId;

  /// Transfer description
  final String? description;

  /// When it was posted
  final DateTime? posted;

  /// When it expire
  final DateTime? expiry;

  /// Transfer amount
  final int? amount;

  /// Available balance
  final int? balance;

  /// Transaction balance
  final int? transactionBalance;

  /// Amount that was redeemed
  final int? redemptionAmount;

  /// Account number in which the transfer were redeemed
  final String? accountRedeemed;

  /// Exchange rate for this transaction
  final num? rate;

  /// Creates a new [LoyaltyPointsTransactionDTO] object
  LoyaltyPointsTransactionDTO({
    this.transactionID,
    this.created,
    this.updated,
    this.transactionType,
    this.loyaltyId,
    this.description,
    this.posted,
    this.expiry,
    this.amount,
    this.balance,
    this.transactionBalance,
    this.redemptionAmount,
    this.accountRedeemed,
    this.rate,
  });

  /// Creates a [LoyaltyPointsTransactionDTO] from json data
  factory LoyaltyPointsTransactionDTO.fromJson(Map<String, dynamic> map) =>
      LoyaltyPointsTransactionDTO(
        transactionID: map['txn_id'],
        created: JsonParser.parseDate((map['ts_created'])),
        updated: JsonParser.parseDate((map['ts_updated'])),
        transactionType:
            LoyaltyPointsTransactionTypeDTO.fromRaw(map['txn_type']),
        loyaltyId: JsonParser.parseInt(map['loyalty_id']),
        description: map['description']?.toString() ?? '',
        posted: JsonParser.parseDate((map['ts_posted'])),
        expiry: JsonParser.parseDate((map['ts_expires'])),
        amount: JsonParser.parseInt(map['amount']),
        balance: JsonParser.parseInt(map['balance']),
        transactionBalance: JsonParser.parseInt(map['txn_balance']),
        redemptionAmount: JsonParser.parseInt(map['redemption_amount']),
        accountRedeemed: map['redemption_account'] ?? '',
        rate: JsonParser.parseDouble(map['rate']) ?? 1.0,
      );

  /// Creates a list of [LoyaltyPointsTransactionDTO] based on a JSON list
  static List<LoyaltyPointsTransactionDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(LoyaltyPointsTransactionDTO.fromJson).toList();
}

/// Mapps a string to the respective [LoyaltyPointsTransactionTypeDTO]
class LoyaltyPointsTransactionTypeDTO extends EnumDTO {
  const LoyaltyPointsTransactionTypeDTO._internal(String value)
      : super.internal(value);

  /// Loyalty Points Earned
  static const earn = LoyaltyPointsTransactionTypeDTO._internal('E');

  /// Loyalty Points exchanged
  static const burn = LoyaltyPointsTransactionTypeDTO._internal('B');

  /// Loyalty Points Transferred
  static const transferred = LoyaltyPointsTransactionTypeDTO._internal('T');

  /// Loyalty Points Expired
  static const expire = LoyaltyPointsTransactionTypeDTO._internal('X');

  /// Loyalty Points Adjusted
  static const adjust = LoyaltyPointsTransactionTypeDTO._internal('A');

  /// No type specified
  static const none = LoyaltyPointsTransactionTypeDTO._internal(' ');

  /// List of possible Types
  static const List<LoyaltyPointsTransactionTypeDTO> values = [
    earn,
    burn,
    transferred,
    expire,
    adjust,
    none,
  ];

  /// Returns a [LoyaltyPointsTransactionTypeDTO] by a given String
  static LoyaltyPointsTransactionTypeDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull((it) => it.value == raw);
}
