import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles expirated loyalty points data
class MockLoyaltyPointsExpirationRepository
    implements LoyaltyPointsExpirationRepositoryInterface {
  final LoyaltyPointsExpirationProvider _provider;

  ///  Creates a new repository with the supplied [LoyaltyPointsProvider]
  MockLoyaltyPointsExpirationRepository(
    LoyaltyPointsExpirationProvider provider,
  ) : _provider = provider;

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
