import '../../models.dart';

/// Abstract repository for the [CardInfo] objects.
abstract class CardInfoRepositoryInterface {
  /// Returns the [CardInfo] object for the passed [cardId].
  Future<CardInfo> getCardInfo({
    required String cardId,
  });

  /// Returns the [CardInfo] object resulting on sending the OTP code for the
  /// passed [cardId].
  Future<CardInfo> sendOTPCode({
    required String cardId,
  });

  /// Returns the [CardInfo] object resulting on verifying the 2FA for the
  /// passed [cardId].
  Future<CardInfo> verifySecondFactor({
    required String cardId,
    required String value,
    required SecondFactorType secondFactorType,
    required int otpId,
  });
}
