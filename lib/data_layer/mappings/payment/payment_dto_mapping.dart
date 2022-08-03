import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../dtos/payment/payment_payload_dto.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [PaymentDTO]
extension PaymentDTOMapping on PaymentDTO {
  /// Maps into a [Payment]
  Payment toPayment() => Payment(
        id: billId,
        created: created,
        updated: updated,
        bill: bill?.toBill(),
        fromAccount: fromAccount?.toAccount(),
        fromCard: fromCard?.toBankingCard(),
        currency: currency ?? '',
        amount: amount,
        amountVisible: amountVisible,
        status: status?.toPaymentStatus() ?? PaymentStatus.unknown,
        scheduled: scheduled,
        recurrence: recurrence?.toRecurrence() ?? Recurrence.none,
        recurrenceStart: recurrenceStart,
        recurrenceEnd: recurrenceEnd,
        otpId: otpId,
        deviceUID: deviceUID,
        secondFactor: secondFactor?.toSecondFactorType(),
      );
}

/// Extension that provides mappings for [PaymentDTOStatus]
extension PaymentDTOStatusMapping on PaymentDTOStatus {
  /// Maps into a [PaymentStatus]
  PaymentStatus toPaymentStatus() {
    switch (this) {
      case PaymentDTOStatus.otp:
        return PaymentStatus.otp;

      case PaymentDTOStatus.otpExpired:
        return PaymentStatus.otpExpired;

      case PaymentDTOStatus.failed:
        return PaymentStatus.failed;

      case PaymentDTOStatus.completed:
        return PaymentStatus.completed;

      case PaymentDTOStatus.pending:
        return PaymentStatus.pending;

      case PaymentDTOStatus.cancelled:
        return PaymentStatus.cancelled;

      case PaymentDTOStatus.scheduled:
        return PaymentStatus.scheduled;

      case PaymentDTOStatus.pendingBank:
        return PaymentStatus.pendingBank;

      case PaymentDTOStatus.pendingExpired:
        return PaymentStatus.pendingExpired;

      default:
        throw MappingException(from: PaymentDTOStatus, to: PaymentStatus);
    }
  }
}

/// Extension that provides mappings for [Payment]
extension PaymentToDTOMapping on Payment {
  /// Maps into a [PaymentDTO]
  PaymentDTO toPaymentDTO() {
    return PaymentDTO(
      paymentId: id,
      created: created,
      bill: bill?.toBillDTO(),
      billId: bill?.billID,
      fromCardId:
          fromCard?.cardId != null ? int.tryParse(fromCard!.cardId) : null,
      fromAccountId: fromAccount?.id,
      amount: amount,
      amountVisible: amountVisible,
      recurrence: recurrence.toRecurrenceDTO(),
      currency: currency,
      status: status.toPaymentStatusDTO(),
      otpId: otpId,
      deviceUID: deviceUID,
      secondFactor: secondFactor?.toSecondFactorTypeDTO(),
      updated: updated,
      scheduled: scheduled,
      recurrenceStart: recurrenceStart,
      recurrenceEnd: recurrenceEnd,
    );
  }
}

/// Extension that provides mappings for [Payment]
extension PaymentToPaymentPayloadDTOMapping on Payment {
  /// Maps into a [PaymentDTO]
  PaymentPayloadDTO toPaymentPayloadDTO() {
    return PaymentPayloadDTO(
      paymentId: id,
      bill: bill?.toBillDTO(),
      amount: amount,
      currency: currency,
      otpId: otpId,
      status: status.toPaymentStatusDTO(),
      deviceUID: deviceUID,
      fromAccount: fromAccount?.toAccountDTO(),
      fromAccountId: fromAccount?.id,
    );
  }
}

/// Extension that provides mappings for [PaymentStatus]
extension PaymentToDTOStatusMapping on PaymentStatus {
  /// Maps into a [PaymentDTOStatus]
  PaymentDTOStatus toPaymentStatusDTO() {
    switch (this) {
      case PaymentStatus.otp:
        return PaymentDTOStatus.otp;

      case PaymentStatus.otpExpired:
        return PaymentDTOStatus.otpExpired;

      case PaymentStatus.failed:
        return PaymentDTOStatus.failed;

      case PaymentStatus.completed:
        return PaymentDTOStatus.completed;

      case PaymentStatus.pending:
        return PaymentDTOStatus.pending;

      case PaymentStatus.cancelled:
        return PaymentDTOStatus.cancelled;

      case PaymentStatus.scheduled:
        return PaymentDTOStatus.scheduled;

      case PaymentStatus.pendingBank:
        return PaymentDTOStatus.pendingBank;

      case PaymentStatus.pendingExpired:
        return PaymentDTOStatus.pendingExpired;

      default:
        throw MappingException(from: PaymentDTOStatus, to: PaymentStatus);
    }
  }
}
