import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../mappings.dart';

/// Handles Loyalty points data
class MockLoyaltyPointsRepository implements LoyaltyPointsRepositoryInterface {
  /// Fetches loyalty points data and parses to [LoyaltyPoints] models
  @override
  Future<List<LoyaltyPoints>> listAllLoyaltyPoints() async {
    await Future.delayed(Duration(seconds: 2));
    final loyaltyPointsDTO = LoyaltyPointsDTO.fromJsonList(
      [
        {'loyalty_id': 1, 'balance': 11111}
      ],
    );

    return loyaltyPointsDTO
        .map((it) => it.toLoyaltyPoints())
        .toList(growable: false);
  }
}
