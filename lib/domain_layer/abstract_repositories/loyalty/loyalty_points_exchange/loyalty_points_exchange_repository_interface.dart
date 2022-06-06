import '../../../models.dart';

/// The abstract repository for the loyalty points exchange.
abstract class LoyaltyPointsExchangeRepositoryInterface {
  /// Makes a burn/redeem of available points
  Future<LoyaltyPointsExchange> postBurn({
    required int amount,
    String? accountId,
    String? cardId,
  });

  /// Complement the burn/redeem but with uses second factor
  Future<LoyaltyPointsExchange> postSecondFactor({
    required String transactionId,
    String? pin,
    String? hardwareToken,
    String? otpId,
    String? otp,
  });
}
