import '../../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mapping for [AccountLoanDTO]
extension AccountLoanPaymentDTOMapping on AccountLoanPaymentDTO {
  /// Returns an [AccountLoanPayment] built from this [AccountLoanPaymentDTO].
  AccountLoanPayment toAccountLoanPayment() {
    return AccountLoanPayment(
      id: id,
      status: status?.toAccountLoanPaymentStatus(),
      amount: amount,
      fees: fees,
      currency: currency,
      feesCurrency: feesCurrency,
      dueDate: maturity,
      serial: paymentSerial,
    );
  }
}

/// Extension that provides mapping for [AccountLoanPaymentStatusDTO]
extension AccountLoanPaymentStatusDTOMapping on AccountLoanPaymentStatusDTO {
  /// Returns an [AccountLoanPaymentStatus] built from
  /// this [AccountLoanPaymentStatusDTO].
  AccountLoanPaymentStatus toAccountLoanPaymentStatus() {
    switch (this) {
      case AccountLoanPaymentStatusDTO.paid:
        return AccountLoanPaymentStatus.paid;

      case AccountLoanPaymentStatusDTO.unpaid:
        return AccountLoanPaymentStatus.unpaid;
    }
    throw MappingException(
      from: AccountLoanPaymentStatusDTO,
      to: AccountLoanPaymentStatus,
    );
  }
}
