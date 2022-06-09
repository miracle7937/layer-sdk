import '../../../dtos.dart';
import '../../../network.dart';

/// Provides data for LoyaltyEngine
class LoyaltyPointsProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [LoyaltyPointsProvider] with a [NetClient] param
  const LoyaltyPointsProvider({
    required this.netClient,
  });

  /// Returns Loyalty points data
  Future<List<LoyaltyPointsDTO>> listAllLoyaltyPoints() async {
    final response = await netClient.request(
      netClient.netEndpoints.loyalty,
      method: NetRequestMethods.get,
    );

    return LoyaltyPointsDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }
}
