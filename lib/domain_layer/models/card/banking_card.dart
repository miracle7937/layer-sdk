import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'card_preferences.dart';
import 'card_type.dart';

/// The [BankingCard] status
enum CardStatus {
  /// Active status
  active,

  /// Inactive status
  inactive,

  /// Closed status
  closed,

  /// Frozen status
  frozen,
}

/// The [BankingCard] provider
enum BankingCardProvider {
  /// American Express
  americanExpress,

  /// Diners club
  dinersClub,

  /// Visa
  visa,

  /// Mastercard
  mastercard,

  /// DiscoverCard
  discoverCard,

  /// Unknown
  unknown,
}

/// A card owned by a [Customer]
class BankingCard extends Equatable {
  /// Unique card identifier
  final String cardId;

  /// Masked card number
  final String? maskedCardNumber;

  /// Card's nickname
  final String? nickname;

  /// Card holder name
  final String? cardHolderName;

  /// Card branch name
  final String? branchName;

  /// Card monthly payment
  final num? monthlyPayment;

  /// Card daily limit
  final num? dailyLimit;

  /// Card's blocked amount
  final num? blockedAmount;

  /// Card credit limit
  final num? creditLimit;

  /// Card remaining limit
  final num? remainingLimit;

  /// If the card is secondary or not
  final bool isSecondary;

  /// Base currency of this card
  final String? currency;

  /// Current card status
  final CardStatus? status;

  /// Formatted expiry date of this card
  final String? formattedExpiryDate;

  /// Holds all the information about the card type
  final CardType type;

  /// Contains all the accountIDs related to this card
  final UnmodifiableListView<String> accountID;

  /// This BankingCard preferences
  final CardPreferences preferences;

  /// Whether its a virtual card or not
  final bool isVirtual;

  /// Creates a new immutable [BankingCard]
  BankingCard({
    required this.cardId,
    this.maskedCardNumber,
    this.nickname,
    this.cardHolderName,
    this.branchName,
    this.monthlyPayment,
    this.dailyLimit,
    this.blockedAmount,
    this.creditLimit,
    this.remainingLimit,
    this.isSecondary = false,
    this.currency,
    required this.status,
    this.formattedExpiryDate,
    this.type = const CardType(),
    required this.preferences,
    Iterable<String> accountIds = const [],
    this.isVirtual = false,
  }) : accountID = UnmodifiableListView(accountIds);

  @override
  List<Object?> get props => [
        cardId,
        maskedCardNumber,
        nickname,
        cardHolderName,
        branchName,
        monthlyPayment,
        dailyLimit,
        blockedAmount,
        creditLimit,
        remainingLimit,
        isSecondary,
        currency,
        status,
        formattedExpiryDate,
        type,
        accountID,
        preferences,
        isVirtual,
      ];

  /// Returns the account related to this card
  String? getCardAccount() => (accountID.isNotEmpty) ? accountID[0] : null;

  /// Returns the card provider
  BankingCardProvider getCardProvider() {
    if (maskedCardNumber?.isEmpty ?? true) return BankingCardProvider.unknown;
    switch (maskedCardNumber![0]) {
      case '3':
        if (maskedCardNumber!.length < 2) return BankingCardProvider.unknown;
        switch (maskedCardNumber![1]) {
          case '7':
            return BankingCardProvider.americanExpress;
          case '8':
            return BankingCardProvider.dinersClub;
        }
        return BankingCardProvider.unknown;
      case '4':
        return BankingCardProvider.visa;
      case '5':
        return BankingCardProvider.mastercard;
      case '6':
        return BankingCardProvider.discoverCard;
      default:
        return BankingCardProvider.unknown;
    }
  }
}
