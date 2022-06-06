import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles expirated loyalty points data
class LoyaltyPointsExpirationRepository
    implements LoyaltyPointsExpirationRepositoryInterface {
  final LoyaltyPointsExpirationProvider _provider;

  ///  Creates a new repository with the supplied [LoyaltyPointsProvider]
  LoyaltyPointsExpirationRepository(LoyaltyPointsExpirationProvider provider)
      : _provider = provider;

  /// Fetches the amount of loyalty points to expire by the set date
  @override
  Future<LoyaltyPointsExpiration> getExpiryPointsByDate({
    required DateTime expirationDate,
  }) async {
    final response =
        await _provider.fetchPointsByDate(expirationDate: expirationDate);

    return response.toLoyaltyPointsExpiration();
  }
}
