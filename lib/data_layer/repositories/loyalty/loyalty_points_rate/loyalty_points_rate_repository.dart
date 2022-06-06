import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles loyalty points rates data.
class LoyaltyPointsRateRepository
    implements LoyaltyPointsRateRepositoryInterface {
  final LoyaltyPointsRateProvider _provider;

  ///  Creates a new repository with the supplied [LoyaltyPointsRateProvider]
  LoyaltyPointsRateRepository(LoyaltyPointsRateProvider provider)
      : _provider = provider;

  /// Fetches the exchange rate list
  @override
  Future<List<LoyaltyPointsRate>> listRates({
    int? offset,
    int? limit,
    String? sortBy,
  }) async {
    final response = await _provider.fetchRates(
      offset: offset,
      limit: limit,
      sortBy: sortBy,
    );

    return response
        .map((it) => it.toLoyaltyPointsRate())
        .toList(growable: false);
  }

  /// Fetches only the current burn rate
  @override
  Future<LoyaltyPointsRate> getCurrentRate({
    bool forceRefesh = false,
  }) async {
    final response =
        await _provider.fetchCurrentRate(forceRefresh: forceRefesh);

    return response.toLoyaltyPointsRate();
  }
}
