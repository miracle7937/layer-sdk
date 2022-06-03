import '../../../../data_layer/network.dart';
import '../dtos.dart';
import '../helpers.dart';

/// Provides data for LoyaltyEngine
class LoyaltyPointsProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [LoyaltyPointsProvider] with a [NetClient] param
  const LoyaltyPointsProvider({
    required this.netClient,
  });

  /// Returns Loyalty data
  Future<List<LoyaltyDTO>> fetchLoyalty() async {
    final response = await netClient.request(
      netClient.netEndpoints.loyalty,
      method: NetRequestMethods.get,
    );

    return LoyaltyDTO.fromJsonList(response.data);
  }

  /// Returns all loyalty transactions
  Future<List<LoyaltyTransactionDTO>> fetchLoyaltyTransactions({
    LoyaltyTransactionTypeDTO? transactionType,
    String? searchQuery,
    int? offset,
    int? limit,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyTransaction,
      method: NetRequestMethods.get,
      queryParameters: {
        if (transactionType != null) "txn_type": transactionType.value,
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (searchQuery != null) 'q': searchQuery,
      },
      forceRefresh: forceRefresh,
    );

    return LoyaltyTransactionDTO.fromJsonList(response.data);
  }

  /// Burn/Redeem Loyalty poins
  Future<LoyaltyExchangeDTO> postBurnPoints({
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

    return LoyaltyExchangeDTO.fromJson(response.data);
  }

  /// Do the second factor post
  Future<LoyaltyExchangeDTO> postSecondFactor({
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

    return LoyaltyExchangeDTO.fromJson(response.data);
  }

  /// Fetch all [LoyaltyRateDTO]
  Future<List<LoyaltyRateDTO>> fetchRates({
    int? offset,
    int? limit,
    String? sortBy,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyBurnRate,
      method: NetRequestMethods.get,
      queryParameters: {
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        if (sortBy != null) 'sortby': sortBy,
      },
      forceRefresh: forceRefresh,
    );

    return LoyaltyRateDTO.fromJsonList(response.data);
  }

  /// Return just the current [LoyaltyRateDTO]
  Future<LoyaltyRateDTO> fetchCurrentRate({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyBurnRateCurrent,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return LoyaltyRateDTO.fromJson(response.data);
  }

  /// Lists amount of points that will expire until a certain date
  Future<LoyaltyExpirationDTO> fetchPointsByDate({
    DateTime? expirationDate,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyExpiry,
      method: NetRequestMethods.get,
    );

    return LoyaltyExpirationDTO.fromJson(response.data);
  }
}
