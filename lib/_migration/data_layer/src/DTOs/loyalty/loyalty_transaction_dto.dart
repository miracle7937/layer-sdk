import 'package:collection/collection.dart';

import '../../helpers.dart';

/// DTO used to used for parsing Loyalty transfers data
class LoyaltyTransactionDTO {
  /// Transaction ID
  final String? transactionID;

  /// When the transaction was created
  final DateTime? created;

  /// When the transaction was updated
  final DateTime? updated;

  /// Transaction type
  final LoyaltyTransactionTypeDTO? transactionType;

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

  /// Creates a new [LoyaltyTransactionDTO] object
  LoyaltyTransactionDTO({
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

  /// Creates a [LoyaltyTransactionDTO] from json data
  factory LoyaltyTransactionDTO.fromJson(Map<String, dynamic> map) {
    return LoyaltyTransactionDTO(
      transactionID: map['txn_id'],
      created: JsonParser.parseDate((map['ts_created'])),
      updated: JsonParser.parseDate((map['ts_updated'])),
      transactionType: LoyaltyTransactionTypeDTO.fromRaw(map['txn_type']),
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
  }

  /// Creates a list of [LoyaltyTransactionDTO] based on a JSON list
  static List<LoyaltyTransactionDTO> fromJsonList(
      List<Map<String, dynamic>> json) {
    return json.map(LoyaltyTransactionDTO.fromJson).toList();
  }
}

/// Mapps a string to the respective [LoyaltyTransactionTypeDTO]
class LoyaltyTransactionTypeDTO extends EnumDTO {
  const LoyaltyTransactionTypeDTO._internal(String value)
      : super.internal(value);

  /// Loyalty Points Earned
  static const earn = LoyaltyTransactionTypeDTO._internal('E');

  /// Loyalty Points exchanged
  static const burn = LoyaltyTransactionTypeDTO._internal('B');

  /// Loyalty Points Transferred
  static const transferred = LoyaltyTransactionTypeDTO._internal('T');

  /// Loyalty Points Expired
  static const expire = LoyaltyTransactionTypeDTO._internal('X');

  /// Loyalty Points Adjusted
  static const adjust = LoyaltyTransactionTypeDTO._internal('A');

  /// No type specified
  static const none = LoyaltyTransactionTypeDTO._internal(' ');

  /// List of possible Types
  static const List<LoyaltyTransactionTypeDTO> values = [
    earn,
    burn,
    transferred,
    expire,
    adjust,
    none,
  ];

  /// Returns a [LoyaltyTransactionTypeDTO] by a given String
  static LoyaltyTransactionTypeDTO? fromRaw(String? raw) {
    return values.firstWhereOrNull(
      (it) => it.value == raw,
    );
  }
}
