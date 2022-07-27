import '../../../domain_layer/models.dart';
import '../../dtos.dart';
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

/// Extension that provides mappings for [RecurrenceDTO]
extension RecurrenceDTOMapping on RecurrenceDTO {
  /// Maps into a [Recurrence]
  Recurrence toRecurrence() {
    switch (this) {
      case RecurrenceDTO.once:
        return Recurrence.once;

      case RecurrenceDTO.daily:
        return Recurrence.daily;

      case RecurrenceDTO.weekly:
        return Recurrence.weekly;

      case RecurrenceDTO.biweekly:
        return Recurrence.biweekly;

      case RecurrenceDTO.monthly:
        return Recurrence.monthly;

      case RecurrenceDTO.bimonthly:
        return Recurrence.bimonthly;

      case RecurrenceDTO.quarterly:
        return Recurrence.quarterly;

      case RecurrenceDTO.yearly:
        return Recurrence.yearly;

      case RecurrenceDTO.endOfEachMonth:
        return Recurrence.endOfEachMonth;

      default:
        return Recurrence.once;
    }
  }
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

/// Extension that provides mappings for [Recurrence]
extension RecurrenceToDTOMapping on Recurrence {
  /// Maps into a [RecurrenceDTO]
  RecurrenceDTO toRecurrenceDTO() {
    switch (this) {
      case Recurrence.once:
        return RecurrenceDTO.once;

      case Recurrence.daily:
        return RecurrenceDTO.daily;

      case Recurrence.weekly:
        return RecurrenceDTO.weekly;

      case Recurrence.biweekly:
        return RecurrenceDTO.biweekly;

      case Recurrence.monthly:
        return RecurrenceDTO.monthly;

      case Recurrence.bimonthly:
        return RecurrenceDTO.bimonthly;

      case Recurrence.quarterly:
        return RecurrenceDTO.quarterly;

      case Recurrence.yearly:
        return RecurrenceDTO.yearly;

      case Recurrence.endOfEachMonth:
        return RecurrenceDTO.endOfEachMonth;

      default:
        return RecurrenceDTO.once;
    }
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
