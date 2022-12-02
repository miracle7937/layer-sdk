import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles the card info for a card.
class CardInfoRepository implements CardInfoRepositoryInterface {
  final CardInfoProvider _provider;

  /// Creates a new [CardInfoRepository] instance
  CardInfoRepository({
    required CardInfoProvider provider,
  }) : _provider = provider;

  /// Returns the [CardInfo] object for the passed [cardId].
  @override
  Future<CardInfo> getCardInfo({
    required String cardId,
  }) async {
    final cardInfoDTO = await _provider.getCardInfo(
      cardId: cardId,
    );

    return cardInfoDTO.toCardInfo();
  }

  /// Returns the [CardInfo] object resulting on sending the OTP code for the
  /// passed [cardId].
  @override
  Future<CardInfo> sendOTPCode({
    required String cardId,
  }) async {
    final cardInfoDTO = await _provider.sendOTPCode(
      cardId: cardId,
    );

    return cardInfoDTO.toCardInfo();
  }

  /// Returns the [CardInfo] object resulting on verifying the 2FA for the
  /// passed [cardId].
  @override
  Future<CardInfo> verifySecondFactor({
    required String cardId,
    required String value,
    required SecondFactorType secondFactorType,
    required int? otpId,
  }) async {
    final cardInfoDTO = await _provider.verifySecondFactor(
      cardId: cardId,
      value: value,
      secondFactorTypeDTO: secondFactorType.toSecondFactorTypeDTO(),
      otpId: otpId,
    );

    return cardInfoDTO.toCardInfo();
  }
}
