import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mappings for [BankingCard]
extension CardMapping on BankingCard {
  /// Maps into a [CardDTO]
  CardDTO toCardDTO() => CardDTO(
        cardId: int.tryParse(cardId),
        maskedCardNumber: maskedCardNumber,
        nickname: nickname,
        cardHolderName: cardHolderName,
        branchName: branchName,
        monthlyPayment: monthlyPayment,
        dailyLimit: dailyLimit,
        blockedAmount: blockedAmount,
        creditLimit: creditLimit,
        remainingLimit: remainingLimit,
        isSecondary: isSecondary,
        currency: currency,
        status: status?.toCardDTOStatus(),
        expiryDate: formattedExpiryDate,
        cardType: type.toCardTypeDTO(),
        accountID: accountID,
        preferences: preferences.toCardPreferencesDTO(),
      );
}

/// Extension that provides mapping for [CardType]
extension CardTypeMapping on CardType {
  /// Maps a [CardType] instance to a [CardTypeDTO] model
  CardTypeDTO toCardTypeDTO() => CardTypeDTO(
        cardCategory: category.toCardCategoryDTO(),
        type: name,
      );
}

/// Extension that provides mapping for [CardStatus]
extension CardStatusMapping on CardStatus {
  /// Maps a [CardStatus] to a [CardDTOStatus]
  CardDTOStatus toCardDTOStatus() {
    switch (this) {
      case CardStatus.active:
        return CardDTOStatus.active;

      case CardStatus.closed:
        return CardDTOStatus.closed;

      case CardStatus.inactive:
        return CardDTOStatus.inactive;

      default:
        throw MappingException(from: CardStatus, to: CardDTOStatus);
    }
  }
}

/// Extension that provides mapping for [CardCategory]
/// Check [CardTypeDTO] for details
/// The category of this card
/// 0 - Debit
/// 1 - Credit
/// 2 - Prepaid
extension CardCategoryMapping on CardCategory {
  /// Maps a [CardCategory] to a [num]
  num toCardCategoryDTO() {
    switch (this) {
      case CardCategory.debit:
        return 0;

      case CardCategory.credit:
        return 1;

      case CardCategory.prepaid:
        return 2;

      default:
        throw MappingException(
          from: CardCategory,
          to: CardCategoryDTO,
        );
    }
  }
}

/// Extension that provides mappings for [CardPreferences]
extension CardPreferencesMapping on CardPreferences {
  /// Maps into a [CardPreferencesDTO]
  CardPreferencesDTO toCardPreferencesDTO() => CardPreferencesDTO(
        nickname: nickname,
        favorite: favorite,
        display: isVisible,
        alertTxn: alertOnTransaction,
        alertPmt: alertOnPayment,
        alertExpiry: alertOnExpiry,
        showBalance: showBalance,
        alertLowCredit: alertOnLowCredit,
        lowCredit: lowCredit,
      );
}
