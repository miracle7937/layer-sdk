import 'package:collection/collection.dart';

import '../../../_migration/data_layer/src/helpers.dart';
import '../preference/card_preferences_dto.dart';
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

  /// Whether its a virtual card or not
  bool? isVirtual;

  /// Mastercard or visa
  CardProviderDTO? provider;

  /// The token used for retrieving the secret for the meawallet sdk.
  String? token;

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
    this.isVirtual,
    this.provider,
    this.token,
  });

  /// Creates a [CardDTO] from a JSON
  factory CardDTO.fromJson(Map<String, dynamic> map) {
    return CardDTO(
      cardId: map['card_id'],
      maskedCardNumber: map['masked_card_no'],
      nickname: map['pref_nickname'],
      provider: map['extra']?['provider'] == null
          ? CardProviderDTO.unknown
          : CardProviderDTO.fromString(map['extra']['provider']),
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
      cardType: map['card_type'] != null
          ? CardTypeDTO.fromJson(map['card_type'])
          : null,
      accountID: List.from(map["account_ids"] ?? []),
      preferences: CardPreferencesDTO.fromJson(map),
      isVirtual: map['virtual'] ?? false,
      token: map['extra'] != null
          ? jsonLookup(map, ['extra', 'card_token'])
          : null,
    );
  }

  /// Creates a list of [CardDTO] from a JSON list
  static List<CardDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(CardDTO.fromJson).toList(growable: false);

  /// Creates a JSON from select data for visibility
  Map<String, dynamic> toVisibilityJson() => {
        'card_id': cardId,
        'masked_card_no': maskedCardNumber,
        'display_name': nickname,
      };
}

/// The [CardDTO] status
class CardDTOStatus extends EnumDTO {
  /// Active status
  static const active = CardDTOStatus._internal('A');

  /// Inactive status
  static const inactive = CardDTOStatus._internal('I');

  /// Frozen status
  static const frozen = CardDTOStatus._internal('F');

  /// Closed status
  static const closed = CardDTOStatus._internal('C');

  /// List of all possible card status
  static const List<CardDTOStatus> values = [
    active,
    inactive,
    frozen,
    closed,
  ];

  const CardDTOStatus._internal(String value) : super.internal(value);

  /// Convert string to [CardDTOStatus]
  static CardDTOStatus? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

/// The available providers for the card
enum CardProviderDTO {
  /// Visa.
  visa('Visa'),

  /// MasterCard.
  mastercard('MasterCard'),

  /// Unknown.
  unknown('unknown');

  /// The string value for the [CardProviderDTO].
  final String value;

  /// Creates a new [CardProviderDTO] with the passed value.
  const CardProviderDTO(this.value);

  /// Creates a new [CardProviderDTO] from a passed string.
  factory CardProviderDTO.fromString(String provider) => values.singleWhere(
        (value) => value.value == provider,
        orElse: () => unknown,
      );
}
