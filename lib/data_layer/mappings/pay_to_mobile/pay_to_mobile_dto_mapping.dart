import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension on [PayToMobileDTO]
extension PayToMobileDTOExtension on PayToMobileDTO {
  /// Maps [PayToMobileDTO] into its model.
  PayToMobile toPayToMobile() => PayToMobile(
        requestId: requestId,
        account: account?.toAccount(),
        toMobile: toMobile,
        requestType: requestTypeDTO?.toRequestType(),
        amount: amount,
        currencyCode: currencyCode,
        status: statusDTO?.toStatus(),
        withdrawalCode: withdrawalCode,
        transactionCode: transactionCode,
        secondFactorType: secondFactorTypeDTO?.toSecondFactorType(),
        created: created,
        expiry: expiry,
      );
}

/// Extension on [PayToMobileRequestTypeDTO].
extension PayToMobileRequestTypeDTOExtension on PayToMobileRequestTypeDTO {
  /// Maps [PayToMobileRequestTypeDTO] into [PayToMobileRequestType].
  PayToMobileRequestType? toRequestType() {
    switch (this) {
      case PayToMobileRequestTypeDTO.selfCash:
        return PayToMobileRequestType.selfCash;

      case PayToMobileRequestTypeDTO.atmCash:
        return PayToMobileRequestType.atmCash;

      case PayToMobileRequestTypeDTO.accountTransfer:
        return PayToMobileRequestType.accountTransfer;

      case PayToMobileRequestTypeDTO.unknown:
        throw MappingException(
          from: PayToMobileRequestTypeDTO,
          to: PayToMobileRequestType,
        );
    }
  }
}

/// Extension on [PayToMobileRequestType].
extension PayToMobileRequestTypeExtension on PayToMobileRequestType {
  /// Maps [PayToMobileRequestType] into [PayToMobileRequestTypeDTO].
  PayToMobileRequestTypeDTO? toRequestTypeDTO() {
    switch (this) {
      case PayToMobileRequestType.selfCash:
        return PayToMobileRequestTypeDTO.selfCash;

      case PayToMobileRequestType.atmCash:
        return PayToMobileRequestTypeDTO.atmCash;

      case PayToMobileRequestType.accountTransfer:
        return PayToMobileRequestTypeDTO.accountTransfer;

      default:
        throw MappingException(
          from: PayToMobileRequestType,
          to: PayToMobileRequestTypeDTO,
        );
    }
  }
}

/// Extension on [PayToMobileStatusDTO].
extension PayToMobileStatusDTOExtension on PayToMobileStatusDTO {
  /// Maps [PayToMobileStatusDTO] into [PayToMobileStatus].
  PayToMobileStatus? toStatus() {
    switch (this) {
      case PayToMobileStatusDTO.completed:
        return PayToMobileStatus.completed;

      case PayToMobileStatusDTO.rejected:
        return PayToMobileStatus.rejected;

      case PayToMobileStatusDTO.pending:
        return PayToMobileStatus.pending;

      case PayToMobileStatusDTO.failed:
        return PayToMobileStatus.failed;

      case PayToMobileStatusDTO.deleted:
        return PayToMobileStatus.deleted;

      case PayToMobileStatusDTO.expired:
        return PayToMobileStatus.expired;

      case PayToMobileStatusDTO.pendingSecondFactor:
        return PayToMobileStatus.pendingSecondFactor;

      case PayToMobileStatusDTO.bankPending:
        return PayToMobileStatus.bankPending;

      case PayToMobileStatusDTO.unknown:
        throw MappingException(
          from: PayToMobileStatusDTO,
          to: PayToMobileStatus,
        );
    }
  }
}

/// Extension on [PayToMobileStatus].
extension PayToMobileStatusExtension on PayToMobileStatus {
  /// Maps [PayToMobileStatus] into [PayToMobileStatusDTO].
  PayToMobileStatusDTO? toStatusDTO() {
    switch (this) {
      case PayToMobileStatus.completed:
        return PayToMobileStatusDTO.completed;

      case PayToMobileStatus.rejected:
        return PayToMobileStatusDTO.rejected;

      case PayToMobileStatus.pending:
        return PayToMobileStatusDTO.pending;

      case PayToMobileStatus.failed:
        return PayToMobileStatusDTO.failed;

      case PayToMobileStatus.deleted:
        return PayToMobileStatusDTO.deleted;

      case PayToMobileStatus.expired:
        return PayToMobileStatusDTO.expired;

      case PayToMobileStatus.pendingSecondFactor:
        return PayToMobileStatusDTO.pendingSecondFactor;

      case PayToMobileStatus.bankPending:
        return PayToMobileStatusDTO.bankPending;

      default:
        throw MappingException(
          from: PayToMobileStatus,
          to: PayToMobileStatusDTO,
        );
    }
  }
}

/// Extension on [PayToMobile].
extension PayToMobileExtension on PayToMobile {
  /// Maps a [PayToMobile] into a [PayToMobileDTO].
  PayToMobileDTO toPayToMobileDTO() => PayToMobileDTO(
        requestId: requestId,
        account: account?.toAccountDTO(),
        toMobile: toMobile,
        requestTypeDTO: requestType?.toRequestTypeDTO(),
        amount: amount,
        currencyCode: currencyCode,
        statusDTO: status?.toStatusDTO(),
        withdrawalCode: withdrawalCode,
        transactionCode: transactionCode,
        secondFactorTypeDTO: secondFactorType?.toSecondFactorTypeDTO(),
        created: created,
        expiry: expiry,
      );
}
