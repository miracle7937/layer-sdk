import '../../../models.dart';

/// The abstract repository for the loyalty points expiration.
// ignore: one_member_abstracts
abstract class LoyaltyPointsExpirationRepositoryInterface {
  /// Fetches the amount of loyalty points to expire by the set date
  Future<LoyaltyPointsExpiration> getExpiryPointsByDate({
    required DateTime expirationDate,
  });
}
