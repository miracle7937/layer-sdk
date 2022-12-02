import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that verifies the second factor for retreiving
/// a [CardInfo] from a card.
class VerifyCardInfoSecondFactorUseCase {
  final CardInfoRepositoryInterface _cardInfoRepository;
  final MeawalletRepositoryInterface _meawalletRepository;

  /// Creates a new [VerifyCardInfoSecondFactorUseCase]
  VerifyCardInfoSecondFactorUseCase({
    required CardInfoRepositoryInterface cardInfoRepository,
    required MeawalletRepositoryInterface meawalletRepository,
  })  : _cardInfoRepository = cardInfoRepository,
        _meawalletRepository = meawalletRepository;

  /// Returns the [CardInfo] resulting on verifying the second factor for
  /// getting the info for the passed [card].
  Future<CardInfo> call({
    required BankingCard card,
    required String value,
    required SecondFactorType secondFactorType,
    required int otpId,
  }) async {
    final cardInfo = await _cardInfoRepository.verifySecondFactor(
      cardId: card.cardId,
      value: value,
      secondFactorType: secondFactorType,
      otpId: otpId,
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
