import '../../../dtos.dart';
import '../../../network.dart';

/// Provides data for the expired loyalty points.
class LoyaltyPointsExpirationProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [LoyaltyPointsExpirationProvider] with a [NetClient] param
  const LoyaltyPointsExpirationProvider({
    required this.netClient,
  });

  /// Lists amount of loyalty points that will expire until a certain date
  Future<LoyaltyPointsExpirationDTO> fetchPointsByDate({
    DateTime? expirationDate,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.loyaltyExpiry,
      method: NetRequestMethods.get,
    );

    return LoyaltyPointsExpirationDTO.fromJson(response.data);
  }
}
