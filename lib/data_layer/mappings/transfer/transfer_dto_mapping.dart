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
        deviceUID: deviceUID,
        amount: amount,
        amountVisible: amountVisible,
        fromAccount: fromAccount?.toAccount(),
        fromCard: fromCard?.toBankingCard(),
        toAccount: toAccount?.toAccount(),
        toCard: toCard?.toBankingCard(),
        fromMobile: fromMobile,
        toMobile: toMobile,
        toBeneficiary: toBeneficiary?.toBeneficiary(),
        recurrence: recurrence?.toRecurrence() ?? Recurrence.none,
        created: created,
        status: status?.toTransferStatus(),
        type: type?.toTransferType(),
        scheduledDate: scheduled,
        bulkFilePath: bulkFilePath ?? '',
        processingType: processingType?.toTransferProcessingType(),
        secondFactorType: secondFactor?.toSecondFactorType(),
        evaluation: evaluation?.toTransferEvaluation(),
        otpId: otpId,
        starts: starts,
        ends: ends,
        reason: reason,
        note: note,
      );
}

/// Extension that provides mappings for [Transfer]
extension TransferToDTOMapping on Transfer {
  /// Maps into a [NewTransferPayloadDTO]
  NewTransferPayloadDTO toTransferShortcutPayloadDTO() {
    return NewTransferPayloadDTO(
      transferId: id,
      fromAccountId: fromAccount?.id,
      toAccountId: toAccount?.id,
      amount: amount ?? 0.0,
      currencyCode: currency ?? '',
      type: type!.toTransferTypeDTO(),
      recurrence: recurrence.toRecurrenceDTO(),
      fromMobile: fromMobile,
    );
  }
}

/// Extension that provides mappings for [TransferStatus]
extension TransferStatusMapping on TransferStatus {
  /// Maps into a [TransferStatusDTO]
  TransferStatusDTO toTransferStatusDTO() {
    switch (this) {
      case TransferStatus.completed:
        return TransferStatusDTO.completed;

      case TransferStatus.pending:
        return TransferStatusDTO.pending;

      case TransferStatus.scheduled:
        return TransferStatusDTO.scheduled;

      case TransferStatus.failed:
        return TransferStatusDTO.failed;

      case TransferStatus.cancelled:
        return TransferStatusDTO.cancelled;

      case TransferStatus.rejected:
        return TransferStatusDTO.rejected;

      case TransferStatus.pendingExpired:
        return TransferStatusDTO.pendingExpired;

      case TransferStatus.otp:
        return TransferStatusDTO.otp;

      case TransferStatus.otpExpired:
        return TransferStatusDTO.otpExpired;

      case TransferStatus.deleted:
        return TransferStatusDTO.deleted;

      default:
        throw MappingException(from: TransferStatus, to: TransferStatusDTO);
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
}

/// Extension that provides mappings for [TransferTypeDTO]
extension TransferTypeDTOMapping on TransferTypeDTO {
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

/// Extension that provides mappings for [TransferType]
extension TransferTypeMapping on TransferType {
  /// Maps into a [TransferTypeDTO]
  TransferTypeDTO toTransferTypeDTO() {
    switch (this) {
      case TransferType.own:
        return TransferTypeDTO.own;

      case TransferType.bank:
        return TransferTypeDTO.bank;

      case TransferType.domestic:
        return TransferTypeDTO.domestic;

      case TransferType.international:
        return TransferTypeDTO.international;

      case TransferType.bulk:
        return TransferTypeDTO.bulk;

      case TransferType.instant:
        return TransferTypeDTO.instant;

      case TransferType.cashIn:
        return TransferTypeDTO.cashin;

      case TransferType.cashOut:
        return TransferTypeDTO.cashout;

      case TransferType.mobileToBeneficiary:
        return TransferTypeDTO.mobileToBeneficiary;

      case TransferType.merchantTransfer:
        return TransferTypeDTO.merchantTransfer;

      default:
        throw MappingException(from: TransferType, to: TransferTypeDTO);
    }
  }
}

/// Extension that provides mappings for [TransferProcessingTypeDTO]
extension TransferProcessingTypeDTOMapping on TransferProcessingTypeDTO {
  /// Maps into a [TransferProcessingType]
  TransferProcessingType toTransferProcessingType() {
    switch (this) {
      case TransferProcessingTypeDTO.instant:
        return TransferProcessingType.instant;

      case TransferProcessingTypeDTO.nextDay:
        return TransferProcessingType.nextDay;

      default:
        throw MappingException(
            from: TransferProcessingTypeDTO, to: TransferProcessingType);
    }
  }
}

/// Extension that provides mappings for [TransferProcessingType]
extension TransferProcessingTypeMapping on TransferProcessingType {
  /// Maps into a [TransferStatusDTO]
  TransferProcessingTypeDTO toTransferProcessingTypeDTO() {
    switch (this) {
      case TransferProcessingType.instant:
        return TransferProcessingTypeDTO.instant;

      case TransferProcessingType.nextDay:
        return TransferProcessingTypeDTO.nextDay;

      default:
        throw MappingException(
            from: TransferProcessingType, to: TransferProcessingTypeDTO);
    }
  }
}
