import '../../../dtos.dart';
import '../../../network.dart';

/// Provides data the loyalty points rates.
class LoyaltyPointsRateProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [LoyaltyPointsRateProvider] with a [NetClient] param
  const LoyaltyPointsRateProvider({
    required this.netClient,
  });

  /// Fetch all [LoyaltyPointsRateDTO]
  Future<List<LoyaltyPointsRateDTO>> fetchRates({
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

    return LoyaltyPointsRateDTO.fromJsonList(response.data);
  }

  /// Return just the current [LoyaltyPointsRateDTO]
  Future<LoyaltyPointsRateDTO> fetchCurrentRate({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyBurnRateCurrent,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return LoyaltyPointsRateDTO.fromJson(response.data);
  }
}
