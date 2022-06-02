import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles Loyalty points data
class LoyaltyPointsRepository implements LoyaltyPointsRepositoryInterface {
  final LoyaltyPointsProvider _provider;

  ///  Creates a new repository with the supplied [LoyaltyPointsProvider]
  LoyaltyPointsRepository(LoyaltyPointsProvider provider)
      : _provider = provider;

  /// Fetches loyalty points data and parses to [LoyaltyPoints] models
  @override
  Future<List<LoyaltyPoints>> listAllLoyaltyPoints() async {
    final loyaltyPointsDTO = await _provider.listAllLoyaltyPoints();

    return loyaltyPointsDTO
        .map((it) => it.toLoyaltyPoints())
        .toList(growable: false);
  }
}
