import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [BillDTO]
extension BillDTOMapping on BillDTO {
  /// Maps into a [Bill]
  Bill toBill() => Bill(
        billID: billId,
        nickname: nickname,
        service: service?.toService(),
        billStatus: status?.toBillStatus(),
        billingNumber: billingNumber,
        billerName: service?.biller?.name,
        created: created,
        amount: amount is double ? amount : 0.0,
        hideValues: amount is String,
      );
}

/// Extension that provides mappings for [BillDTOStatus]
extension BillDTOStatusMapping on BillDTOStatus {
  /// Maps into a [BillStatus]
  BillStatus toBillStatus() {
    switch (this) {
      case BillDTOStatus.active:
        return BillStatus.active;

      case BillDTOStatus.inactive:
        return BillStatus.inactive;

      case BillDTOStatus.otp:
        return BillStatus.otp;

      case BillDTOStatus.deleted:
        return BillStatus.deleted;

      default:
        throw MappingException(from: BillDTOStatus, to: BillStatus);
    }
  }
}
