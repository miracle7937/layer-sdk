import '../../../models.dart';

/// The abstract repository for the loyalty points.
// ignore: one_member_abstracts
abstract class LoyaltyPointsRepositoryInterface {
  /// Fetches loyalty points data and parses to [LoyaltyPoints] models
  Future<List<LoyaltyPoints>> listAllLoyaltyPoints();
}
