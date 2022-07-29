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
        billStatus: status?.toBillStatus() ?? BillStatus.unknown,
        billingNumber: billingNumber,
        billerName: service?.biller?.name,
        created: created,
        amount: amount is double ? amount : 0.0,
        hideValues: amount is String,
        billingFields: (billingFields ?? [])
            .map((e) => e.toServiceField())
            .toList(growable: false),
        visible: visible ?? false,
        fees: fees ?? 0,
        customerId: customerId,
        recurring: recurring ?? false,
        feesCurrency: feesCurrency,
        secondFactor: secondFactor?.toSecondFactorType(),
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
        throw MappingException(
          from: BillDTOStatus,
          to: BillStatus,
          value: this,
        );
    }
  }
}

/// Extension that provides mappings for [Bill]
extension BillToDTOMapping on Bill {
  /// Maps into a [BillStatus]
  BillDTO toBillDTO() {
    return BillDTO(
      billId: billID,
      nickname: nickname,
      serviceId: service?.serviceId,
      service: service?.toServiceDTO(),
      billingNumber: billingNumber,
      amount: amount,
      billingFields: billingFields
          .map((e) => e.toServiceFieldDTO())
          .toList(growable: false),
      visible: visible,
      fees: fees,
      customerId: customerId,
      recurring: recurring,
      status: billStatus.toBillDTOStatus(),
      feesCurrency: feesCurrency,
      secondFactor: secondFactor?.toSecondFactorTypeDTO(),
    );
  }
}

/// Extension that provides mappings for [BillStatus]
extension BillStatusMapping on BillStatus {
  /// Maps into a [BillDTOStatus]
  BillDTOStatus toBillDTOStatus() {
    switch (this) {
      case BillStatus.active:
        return BillDTOStatus.active;

      case BillStatus.inactive:
        return BillDTOStatus.inactive;

      case BillStatus.otp:
        return BillDTOStatus.otp;

      case BillStatus.deleted:
        return BillDTOStatus.deleted;

      default:
        throw MappingException(
          from: BillStatus,
          to: BillDTOStatus,
          value: this,
        );
    }
  }
}
