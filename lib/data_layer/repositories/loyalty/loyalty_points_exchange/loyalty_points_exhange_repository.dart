import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles Loyalty points exchanges data
class LoyaltyPointsExchangeRepository
    implements LoyaltyPointsExchangeRepositoryInterface {
  final LoyaltyPointsExchangeProvider _provider;

  ///  Creates a new repository with the supplied [LoyaltyPointsExchangeProvider]
  LoyaltyPointsExchangeRepository(LoyaltyPointsExchangeProvider provider)
      : _provider = provider;

  /// Makes a burn/redeem of available points
  @override
  Future<LoyaltyPointsExchange> postBurn({
    required int amount,
    String? accountId,
    String? cardId,
  }) async {
    final response = await _provider.postBurnPoints(
      amount: amount,
      accountId: accountId,
      cardId: cardId,
    );

    return response.toLoyaltyPointsExchange();
  }

  /// Complement the burn/redeem but with uses second factor
  @override
  Future<LoyaltyPointsExchange> postSecondFactor({
    required String transactionId,
    String? pin,
    String? hardwareToken,
    String? otpId,
    String? otp,
  }) async {
    final response = await _provider.postSecondFactor(
      transactionId: transactionId,
      pin: pin,
      hardwareToken: hardwareToken,
      otp: otp,
      otpId: otpId,
    );

    return response.toLoyaltyPointsExchange();
  }
}
