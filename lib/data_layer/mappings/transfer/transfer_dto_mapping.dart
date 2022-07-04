import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [TransferDTO]
extension TransferDTOMapping on TransferDTO {
  /// Maps into a [Transfer]
  Transfer toTransfer() => Transfer(
        id: id,
        currency: currency,
        amount: amount,
        amountVisible: amountVisible,
        fromAccount: fromAccount?.toAccount(),
        fromCard: fromCard?.toBankingCard(),
        toAccount: toAccount?.toAccount(),
        toCard: toCard?.toBankingCard(),
        fromMobile: fromMobile,
        toMobile: toMobile,
        toBeneficiary: toBeneficiary?.toBeneficiary(),
        recurrence:
            recurrence?.toTransferRecurrence() ?? TransferRecurrence.none,
        created: created,
        status: status?.toTransferStatus(),
        type: type?.toTransferType(),
        scheduledDate: scheduled,
      );

  /// Maps into a [StandingOrder]
  StandingOrder toStandingOrder() => StandingOrder(
        id: id,
        currency: currency,
        amount: amount,
        amountVisible: amountVisible,
        fromAccount: fromAccount?.toAccount(),
        fromCard: fromCard?.toBankingCard(),
        toAccount: toAccount?.toAccount(),
        toCard: toCard?.toBankingCard(),
        fromMobile: fromMobile,
        toMobile: toMobile,
        toBeneficiary: toBeneficiary?.toBeneficiary(),
        recurrence: recurrence?.toStandingOrderRecurrence() ??
            StandingOrderRecurrence.none,
        created: created,
        status: status?.toStandingOrderStatus(),
        type: type?.toStandingOrderType(),
        scheduledDate: scheduled,
      );
}

/// Extension that provides mappings for [TransferRecurrenceDTO]
extension TransferRecurrenceDTOMapping on TransferRecurrenceDTO {
  /// Maps into a [TransferRecurrence]
  TransferRecurrence toTransferRecurrence() {
    switch (this) {
      case TransferRecurrenceDTO.once:
        return TransferRecurrence.once;

      case TransferRecurrenceDTO.daily:
        return TransferRecurrence.daily;

      case TransferRecurrenceDTO.weekly:
        return TransferRecurrence.weekly;

      case TransferRecurrenceDTO.biweekly:
        return TransferRecurrence.biweekly;

      case TransferRecurrenceDTO.monthly:
        return TransferRecurrence.monthly;

      case TransferRecurrenceDTO.bimonthly:
        return TransferRecurrence.bimonthly;

      case TransferRecurrenceDTO.quarterly:
        return TransferRecurrence.quarterly;

      case TransferRecurrenceDTO.yearly:
        return TransferRecurrence.yearly;

      case TransferRecurrenceDTO.endOfEachMonth:
        return TransferRecurrence.endOfEachMonth;

      default:
        return TransferRecurrence.none;
    }
  }

  /// Maps into a [StandingOrderRecurrence]
  StandingOrderRecurrence toStandingOrderRecurrence() {
    switch (this) {
      case TransferRecurrenceDTO.once:
        return StandingOrderRecurrence.once;

      case TransferRecurrenceDTO.daily:
        return StandingOrderRecurrence.daily;

      case TransferRecurrenceDTO.weekly:
        return StandingOrderRecurrence.weekly;

      case TransferRecurrenceDTO.biweekly:
        return StandingOrderRecurrence.biweekly;

      case TransferRecurrenceDTO.monthly:
        return StandingOrderRecurrence.monthly;

      case TransferRecurrenceDTO.bimonthly:
        return StandingOrderRecurrence.bimonthly;

      case TransferRecurrenceDTO.quarterly:
        return StandingOrderRecurrence.quarterly;

      case TransferRecurrenceDTO.yearly:
        return StandingOrderRecurrence.yearly;

      case TransferRecurrenceDTO.endOfEachMonth:
        return StandingOrderRecurrence.endOfEachMonth;

      default:
        return StandingOrderRecurrence.none;
    }
  }
}

/// Extension that provides mappings for [TransferStatusDTO]
extension TransferStatusDTOMapping on TransferStatusDTO {
  /// Maps into a [TransferStatus]
  TransferStatus toTransferStatus() {
    switch (this) {
      case TransferStatusDTO.completed:
        return TransferStatus.completed;

      case TransferStatusDTO.pending:
        return TransferStatus.pending;

      case TransferStatusDTO.scheduled:
        return TransferStatus.scheduled;

      case TransferStatusDTO.failed:
        return TransferStatus.failed;

      case TransferStatusDTO.cancelled:
        return TransferStatus.cancelled;

      case TransferStatusDTO.rejected:
        return TransferStatus.rejected;

      case TransferStatusDTO.pendingExpired:
        return TransferStatus.pendingExpired;

      case TransferStatusDTO.otp:
        return TransferStatus.otp;

      case TransferStatusDTO.otpExpired:
        return TransferStatus.otpExpired;

      case TransferStatusDTO.deleted:
        return TransferStatus.deleted;

      default:
        throw MappingException(from: TransferStatusDTO, to: TransferStatus);
    }
  }

  /// Maps into a [StandingOrderStatus]
  StandingOrderStatus toStandingOrderStatus() {
    switch (this) {
      case TransferStatusDTO.completed:
        return StandingOrderStatus.completed;

      case TransferStatusDTO.pending:
        return StandingOrderStatus.pending;

      case TransferStatusDTO.scheduled:
        return StandingOrderStatus.scheduled;

      case TransferStatusDTO.failed:
        return StandingOrderStatus.failed;

      case TransferStatusDTO.cancelled:
        return StandingOrderStatus.cancelled;

      case TransferStatusDTO.rejected:
        return StandingOrderStatus.rejected;

      case TransferStatusDTO.pendingExpired:
        return StandingOrderStatus.pendingExpired;

      case TransferStatusDTO.otp:
        return StandingOrderStatus.otp;

      case TransferStatusDTO.otpExpired:
        return StandingOrderStatus.otpExpired;

      case TransferStatusDTO.deleted:
        return StandingOrderStatus.deleted;

      default:
        throw MappingException(
          from: TransferStatusDTO,
          to: StandingOrderStatus,
        );
    }
  }
}

/// Extension that provides mappings for [TransferTypeDTO]
extension TransferTypeDTOMapping on TransferTypeDTO {
  /// Maps into a [StandingOrderType]
  StandingOrderType toStandingOrderType() {
    switch (this) {
      case TransferTypeDTO.own:
        return StandingOrderType.own;

      case TransferTypeDTO.bank:
        return StandingOrderType.bank;

      case TransferTypeDTO.domestic:
        return StandingOrderType.domestic;

      case TransferTypeDTO.international:
        return StandingOrderType.international;

      case TransferTypeDTO.bulk:
        return StandingOrderType.bulk;

      case TransferTypeDTO.instant:
        return StandingOrderType.instant;

      case TransferTypeDTO.cashin:
        return StandingOrderType.cashIn;

      case TransferTypeDTO.cashout:
        return StandingOrderType.cashOut;

      case TransferTypeDTO.mobileToBeneficiary:
        return StandingOrderType.mobileToBeneficiary;

      case TransferTypeDTO.merchantTransfer:
        return StandingOrderType.merchantTransfer;

      default:
        throw MappingException(from: TransferTypeDTO, to: StandingOrderType);
    }
  }

  /// Maps into a [TransferType]
  TransferType toTransferType() {
    switch (this) {
      case TransferTypeDTO.own:
        return TransferType.own;

      case TransferTypeDTO.bank:
        return TransferType.bank;

      case TransferTypeDTO.domestic:
        return TransferType.domestic;

      case TransferTypeDTO.international:
        return TransferType.international;

      case TransferTypeDTO.bulk:
        return TransferType.bulk;

      case TransferTypeDTO.instant:
        return TransferType.instant;

      case TransferTypeDTO.cashin:
        return TransferType.cashIn;

      case TransferTypeDTO.cashout:
        return TransferType.cashOut;

      case TransferTypeDTO.mobileToBeneficiary:
        return TransferType.mobileToBeneficiary;

      case TransferTypeDTO.merchantTransfer:
        return TransferType.merchantTransfer;

      default:
        throw MappingException(from: TransferTypeDTO, to: TransferType);
    }
  }
}
