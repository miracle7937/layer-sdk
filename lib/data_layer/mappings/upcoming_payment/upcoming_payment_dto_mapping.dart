import '../../../_migration/data_layer/src/mappings.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [UpcomingPaymentDTO]
extension UpcomingPaymentDTOMapping on UpcomingPaymentDTO {
  /// Maps into a [UpcomingPayment]
  UpcomingPayment toUpcomingPayment() => UpcomingPayment(
        id: id,
        merchantName: merchantName,
        date: maturityDate,
        amount: amount,
        currency: currency,
        status: status?.toUpcomingPaymentStatus(),
        totalPayments: totalPayments,
        currentPayment: currentPayment,
        nickname: nickName,
        name: name,
        recurrence: recurrence,
        dateTime: dateTime,
        number: number,
        paymentType: paymentType?.toUpcomingPaymentType(),
        transfer: transfer?.toTransfer(),
        bill: bill?.toBill(),
        isNameLocalized: isNameLocalized,
      );
}

/// Extension that provides mappings for [UpcomingPaymentStatusDTO]
extension UpcomingPaymentStatusDTOMapping on UpcomingPaymentStatusDTO {
  /// Maps into a [UpcomingPaymentStatus]
  UpcomingPaymentStatus toUpcomingPaymentStatus() {
    switch (this) {
      case UpcomingPaymentStatusDTO.paid:
        return UpcomingPaymentStatus.paid;

      case UpcomingPaymentStatusDTO.unpaid:
        return UpcomingPaymentStatus.unpaid;

      default:
        throw MappingException(
          from: UpcomingPaymentStatusDTO,
          to: UpcomingPaymentStatus,
        );
    }
  }
}

/// Extension that provides mappings for [UpcomingPaymentTypeDTO]
extension UpcomingPaymentTypeDTOMapping on UpcomingPaymentTypeDTO {
  /// Maps into a [UpcomingPaymentType]
  UpcomingPaymentType toUpcomingPaymentType() {
    switch (this) {
      case UpcomingPaymentTypeDTO.accountLoan:
        return UpcomingPaymentType.accountLoan;

      case UpcomingPaymentTypeDTO.bill:
        return UpcomingPaymentType.bill;

      case UpcomingPaymentTypeDTO.recurringTransfer:
        return UpcomingPaymentType.recurringTransfer;

      case UpcomingPaymentTypeDTO.recurringPayment:
        return UpcomingPaymentType.recurringPayment;

      case UpcomingPaymentTypeDTO.financeAccount:
        return UpcomingPaymentType.financeAccount;

      case UpcomingPaymentTypeDTO.creditCard:
        return UpcomingPaymentType.creditCard;

      case UpcomingPaymentTypeDTO.goal:
        return UpcomingPaymentType.goal;

      default:
        throw MappingException(
          from: UpcomingPaymentTypeDTO,
          to: UpcomingPaymentType,
        );
    }
  }
}

/// Extension that provides mappings for [UpcomingPaymentType]
extension UpcomingPaymentTypeMapping on UpcomingPaymentType {
  /// Maps into a [UpcomingPaymentTypeDTO]
  UpcomingPaymentTypeDTO toUpcomingPaymentTypeDTO() {
    switch (this) {
      case UpcomingPaymentType.accountLoan:
        return UpcomingPaymentTypeDTO.accountLoan;

      case UpcomingPaymentType.bill:
        return UpcomingPaymentTypeDTO.bill;

      case UpcomingPaymentType.recurringTransfer:
        return UpcomingPaymentTypeDTO.recurringTransfer;

      case UpcomingPaymentType.recurringPayment:
        return UpcomingPaymentTypeDTO.recurringPayment;

      case UpcomingPaymentType.financeAccount:
        return UpcomingPaymentTypeDTO.financeAccount;

      case UpcomingPaymentType.creditCard:
        return UpcomingPaymentTypeDTO.creditCard;

      case UpcomingPaymentType.goal:
        return UpcomingPaymentTypeDTO.goal;

      default:
        throw MappingException(
          from: UpcomingPaymentTypeDTO,
          to: UpcomingPaymentType,
        );
    }
  }
}
