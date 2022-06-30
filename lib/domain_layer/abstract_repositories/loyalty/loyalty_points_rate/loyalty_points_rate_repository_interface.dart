import '../../../models.dart';

/// The abstract repository for the loyalty points rate.
abstract class LoyaltyPointsRateRepositoryInterface {
  /// Fetches the exchange rate list
  Future<List<LoyaltyPointsRate>> listRates({
    int? offset,
    int? limit,
    String? sortBy,
  });

  /// Fetches only the current burn rate
  Future<LoyaltyPointsRate> getCurrentRate({
    bool forceRefesh = false,
  });
}
