import '../../../../data_layer/mappings.dart';
import '../../errors.dart';
import '../../models.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Extension that provides mappings for [PaymentDTO]
extension PaymentDTOMapping on PaymentDTO {
  /// Maps into a [Payment]
  Payment toPayment() => Payment(
        id: billId,
        created: created,
        bill: bill?.toBill(),
        fromAccount: fromAccount?.toAccount(),
        fromCard: fromCard?.toBankingCard(),
        currency: currency ?? '',
        amount: amount,
        amountVisible: amountVisible,
        status: status?.toPaymentStatus() ?? PaymentStatus.unknown,
        scheduled: scheduled,
        recurrence: recurrence?.toRecurrence() ?? Recurrence.none,
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
