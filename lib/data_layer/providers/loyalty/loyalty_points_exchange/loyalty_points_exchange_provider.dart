import '../../../dtos.dart';
import '../../../helpers.dart';
import '../../../network.dart';

/// Provides data for the loyalty points exchanges
class LoyaltyPointsExchangeProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [LoyaltyPointsExchangeProvider] with a [NetClient] param
  const LoyaltyPointsExchangeProvider({
    required this.netClient,
  });

  /// Burn/Redeem Loyalty poins
  Future<LoyaltyPointsExchangeDTO> postBurnPoints({
    required int amount,
    String? accountId,
    String? cardId,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyBurn,
      method: NetRequestMethods.post,
      data: {
        "amount": amount,
        "account_id": accountId,
        "card_id": cardId,
      },
    );

    return LoyaltyPointsExchangeDTO.fromJson(response.data);
  }

  /// Do the second factor post
  Future<LoyaltyPointsExchangeDTO> postSecondFactor({
    required String transactionId,
    String? pin,
    String? hardwareToken,
    String? otpId,
    String? otp,
  }) async {
    assert(pin != null || hardwareToken != null || otp != null);

    final data = {"txn_id": transactionId};

    if (pin != null) {
      data['pin'] = pin;
    } else if (hardwareToken != null) {
      data['hardware_token'] = hardwareToken;
    }

    final params = {
      if (isNotEmpty(otp)) "otp_value": otp,
      if (isNotEmpty(otpId)) 'otp_id': otpId,
    };

    final response = await netClient.request(
      netClient.netEndpoints.loyaltyBurn,
      method: NetRequestMethods.post,
      data: data,
      queryParameters: params,
    );

    return LoyaltyPointsExchangeDTO.fromJson(response.data);
  }
}
