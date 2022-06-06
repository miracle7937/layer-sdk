import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../errors.dart';

/// Mapper for [LoyaltyPointsDTO] class
extension LoyaltyDTOMapping on LoyaltyPointsDTO {
  /// Maps [LoyaltyPointsDTO] to [LoyaltyPoints]
  LoyaltyPoints toLoyaltyPoints() => LoyaltyPoints(
        id: loyaltyId!,
        created: created,
        updated: updated,
        status:
            (status ?? LoyaltyPointsStatusDTO.deleted).toLoyaltyPointsStatus(),
        balance: balance ?? 0,
        earned: earned ?? 0,
        burned: burned ?? 0,
        transferred: transferred ?? 0,
        adjusted: adjusted ?? 0,
        lastTransactionDate: lastTxn,
      );
}

/// Extension for mapping the [LoyaltyPointsStatusDTO]
extension LoyaltyStatusDTOMapping on LoyaltyPointsStatusDTO {
  /// Maps [LoyaltyPointsStatusDTO] to [LoyaltyPointsStatus]
  LoyaltyPointsStatus toLoyaltyPointsStatus() {
    switch (this) {
      case LoyaltyPointsStatusDTO.active:
        return LoyaltyPointsStatus.active;

      case LoyaltyPointsStatusDTO.deleted:
        return LoyaltyPointsStatus.deleted;

      default:
        throw MappingException(
          from: LoyaltyPointsStatusDTO,
          to: LoyaltyPointsStatus,
        );
    }
  }
}
