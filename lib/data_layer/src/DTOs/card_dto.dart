import 'package:collection/collection.dart';

import '../helpers.dart';
import 'card_preferences_dto.dart';
import 'card_type_dto.dart';

/// Represents the customers card
/// as provided by the infobanking service
class CardDTO {
  /// Unique card identifier
  int? cardId;

  /// Masked card number
  String? maskedCardNumber;

  /// Card's nickname
  String? nickname;

  /// Card holder name
  String? cardHolderName;

  /// Card branch name
  String? branchName;

  /// Card monthly payment
  num? monthlyPayment;

  /// Card daily limit
  num? dailyLimit;

  /// Card's blocked amount
  num? blockedAmount;

  /// Card credit limit
  num? creditLimit;

  /// Card remaining limit
  num? remainingLimit;

  /// If the card is secondary or not
  bool? isSecondary;

  /// Base currency of this card
  String? currency;

  /// Current card status
  CardDTOStatus? status;

  /// Formatted expiry date of this card
  String? expiryDate;

  /// Contains all information about the card type
  CardTypeDTO? cardType;

  /// Contains all the accountIDs related to this card
  List<String>? accountID;

  /// Contains all preferences related to this card
  CardPreferencesDTO? preferences;

  /// Creates a new [CardDTO]
  CardDTO({
    this.cardId,
    this.maskedCardNumber,
    this.nickname,
    this.cardHolderName,
    this.branchName,
    this.monthlyPayment,
    this.dailyLimit,
    this.blockedAmount,
    this.creditLimit,
    this.remainingLimit,
    this.isSecondary,
    this.currency,
    this.status,
    this.expiryDate,
    this.cardType,
    this.accountID,
    this.preferences,
  });

  /// Creates a [CardDTO] from a JSON
  factory CardDTO.fromJson(Map<String, dynamic> map) {
    return CardDTO(
      cardId: map['card_id'],
      maskedCardNumber: map['masked_card_no'],
      nickname: map['pref_nickname'],
      cardHolderName: map['holder_name'],
      branchName: map['extra'] != null
          ? jsonLookup(map, ['extra', 'branch_name'])
          : null,
      monthlyPayment: map['monthly_payment'],
      dailyLimit: map['extra'] != null
          ? jsonLookup(map, ['extra', 'daily_limit'])
          : null,
      blockedAmount: map['extra'] != null
          ? jsonLookup(map, ['extra', 'blocked_amount'])
          : null,
      creditLimit: map['credit_limit'],
      remainingLimit: map['remaining_limit'],
      isSecondary: map["is_secondary"] ?? true,
      currency: map['currency'],
      status: CardDTOStatus.fromRaw(map['status']),
      expiryDate: map['expiry_date'],
      cardType: CardTypeDTO.fromJson(map['card_type']),
      accountID: List.from(map["account_ids"] ?? []),
      preferences: CardPreferencesDTO.fromJson(map),
    );
  }

  /// Creates a list of [CardDTO] from a JSON list
  static List<CardDTO> fromJsonList(List json) =>
      json.map((x) => CardDTO.fromJson(x)).toList(growable: false);
}

/// The [CardDTO] status
class CardDTOStatus extends EnumDTO {
  /// Active status
  static const active = CardDTOStatus._internal('A');

  /// Inactive status
  static const inactive = CardDTOStatus._internal('I');

  /// Closed status
  static const closed = CardDTOStatus._internal('C');

  /// List of all possible card status
  static const List<CardDTOStatus> values = [
    active,
    inactive,
    closed,
  ];

  const CardDTOStatus._internal(String value) : super.internal(value);

  /// Convert string to [CardDTOStatus]
  static CardDTOStatus? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
