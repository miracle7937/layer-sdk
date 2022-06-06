import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';

///Extension for mapping the [LoyaltyPointsExpirationDTO]
extension LoyaltyExpirationMapping on LoyaltyPointsExpirationDTO {
  ///Maps [LoyaltyPointsExpirationDTO] into [LoyaltyPointsExpiration]
  LoyaltyPointsExpiration toLoyaltyPointsExpiration() =>
      LoyaltyPointsExpiration(
        amount: amount ?? 0,
      );
}
