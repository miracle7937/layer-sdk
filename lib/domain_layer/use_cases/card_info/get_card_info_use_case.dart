import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible of getting the card info from a card id.
class GetCardInfoUseCase {
  final CardInfoRepositoryInterface _cardInfoRepository;
  final MeawalletRepositoryInterface _meawalletRepository;

  /// Creates a new [GetCardInfoUseCase]
  GetCardInfoUseCase({
    required CardInfoRepositoryInterface cardInfoRepository,
    required MeawalletRepositoryInterface meawalletRepository,
  })  : _cardInfoRepository = cardInfoRepository,
        _meawalletRepository = meawalletRepository;

  /// Returns the [CardInfo] for the passed [card].
  Future<CardInfo> call({
    required BankingCard card,
  }) async {
    final cardInfo = await _cardInfoRepository.getCardInfo(
      cardId: card.cardId,
    );

    final cardToken = card.token;
    if (cardInfo.secondFactorType == null && cardToken != null) {
      final secret = await _meawalletRepository.getSecretFromCardToken(
        cardToken: cardToken,
      );

      final meawalletCardDetails = await _meawalletRepository.getCardDetails(
        cardId: cardToken,
        secret: secret,
      );

      return cardInfo.copyWith(
        unmaskedCardNumber: meawalletCardDetails.cardPan,
        cvv: meawalletCardDetails.cardCvv,
      );
    }

    return cardInfo;
  }
}
