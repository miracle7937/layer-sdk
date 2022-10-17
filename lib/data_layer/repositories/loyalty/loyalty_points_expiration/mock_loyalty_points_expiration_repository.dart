import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../mappings.dart';

/// Handles expirated loyalty points data
class MockLoyaltyPointsExpirationRepository
    implements LoyaltyPointsExpirationRepositoryInterface {
  /// Fetches the amount of loyalty points to expire by the set date
  @override
  Future<LoyaltyPointsExpiration> getExpiryPointsByDate({
    required DateTime expirationDate,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    final response = LoyaltyPointsExpirationDTO.fromJson({'amount': 50});

    return response.toLoyaltyPointsExpiration();
  }
}
