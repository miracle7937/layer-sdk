import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';

/// Extension for mapping the [LoyaltyPointsRateDTO]
extension LoyaltyPointsRateMapping on LoyaltyPointsRateDTO {
  /// Maps [LoyaltyPointsRateDTO] on [LoyaltyPointsRate]
  LoyaltyPointsRate toLoyaltyPointsRate() => LoyaltyPointsRate(
        id: id!,
        rate: rate ?? 0.0,
        createdAt: createdAt,
        updatedAt: updatedAt,
        startDate: startDate,
      );
}
