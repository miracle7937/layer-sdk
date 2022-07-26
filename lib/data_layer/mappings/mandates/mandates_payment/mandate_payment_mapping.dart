import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';

/// Mapper for [MandatePaymentDTO] class
extension MandatePaymentMapper on MandatePaymentDTO {
  /// Maps [MandatePaymentDTO] to [MandatePayment]
  MandatePayment toMandatePaymentDTO() {
    return MandatePayment(
      paymentId: paymentId ?? 0,
      mandateId: mandateId ?? 0,
      bankPaymentId: bankPaymentId ?? '',
      status:
          status?.toMandatePaymentStatusDTO() ?? MandatePaymentStatus.unknown,
      amount: amount ?? 0.0,
      reference: reference ?? '',
      currency: currency ?? '',
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
    );
  }
}

/// Mapper for [MandatePaymentStatusDTO] class
extension MandatePaymentStatusDTOMapper on MandatePaymentStatusDTO {
  /// Maps [MandateStatusDTO] to [MandatePaymentStatus]
  MandatePaymentStatus toMandatePaymentStatusDTO() {
    switch (this) {
      case MandatePaymentStatusDTO.active:
        return MandatePaymentStatus.active;
      case MandatePaymentStatusDTO.returning:
        return MandatePaymentStatus.returning;
      case MandatePaymentStatusDTO.accepted:
        return MandatePaymentStatus.accepted;
      case MandatePaymentStatusDTO.pending:
        return MandatePaymentStatus.pending;
      case MandatePaymentStatusDTO.declined:
        return MandatePaymentStatus.declined;
      default:
        return MandatePaymentStatus.unknown;
    }
  }
}
