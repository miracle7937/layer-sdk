import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mapping for [CardDTO]
extension CardDTOMapping on CardDTO {
  /// Maps a [CardDTO] instance to a [BankingCard] model
  BankingCard toBankingCard() => BankingCard(
        cardId: cardId?.toString() ?? '',
        currency: currency,
        nickname: nickname,
        cardHolderName: cardHolderName,
        branchName: branchName,
        monthlyPayment: monthlyPayment,
        dailyLimit: dailyLimit,
        isSecondary: isSecondary ?? false,
        formattedExpiryDate: expiryDate,
        remainingLimit: remainingLimit,
        maskedCardNumber: maskedCardNumber,
        type: cardType?.toCardType() ?? CardType(),
        status: status?.toCardStatus(),
        accountIds: accountID ?? [],
        preferences: preferences?.toCardPreferences() ?? CardPreferences(),
        isVirtual: isVirtual ?? false,
      );
}

/// Extension that provides mapping for [CardTypeDTO]
extension CardTypeDTOMapping on CardTypeDTO {
  /// Maps a [CardTypeDTO] instance to a [CardType] model
  CardType toCardType() {
    CardCategory category;

    switch (cardCategory) {
      case 0:
        category = CardCategory.debit;
        break;

      case 1:
        category = CardCategory.credit;
        break;

      case 2:
        category = CardCategory.prepaid;
        break;

      default:
        throw MappingException(from: CardTypeDTO, to: CardType);
    }

    return CardType(
      category: category,
      name: type,
      canFreezeCard: canFreezeCard ?? true,
      canStopCard: canStopCard ?? true,
      image: image,
    );
  }
}

/// Extension that provides mapping for [CardDTOStatus]
extension CardDTOStatusMapping on CardDTOStatus {
  /// Maps a [CardDTOStatus] to a [CardStatus]
  CardStatus toCardStatus() {
    switch (this) {
      case CardDTOStatus.active:
        return CardStatus.active;

      case CardDTOStatus.closed:
        return CardStatus.closed;

      case CardDTOStatus.inactive:
        return CardStatus.inactive;

      case CardDTOStatus.frozen:
        return CardStatus.frozen;

      default:
        throw MappingException(from: CardDTOStatus, to: CardStatus);
    }
  }
}

/// Extension that provides mapping for [CardCategoryDTO]
extension CardCategoryDTOMapping on CardCategoryDTO {
  /// Maps a [CardCategoryDTO] to a [CardCategory]
  CardCategory toCardCategory() {
    switch (this) {
      case CardCategoryDTO.debit:
        return CardCategory.debit;

      case CardCategoryDTO.credit:
        return CardCategory.credit;

      case CardCategoryDTO.prepaid:
        return CardCategory.prepaid;

      default:
        throw MappingException(from: CardCategoryDTO, to: CardCategory);
    }
  }
}
