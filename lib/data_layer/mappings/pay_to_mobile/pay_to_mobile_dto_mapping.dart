import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension on [PayToMobileDTO]
extension PayToMobileDTOExtension on PayToMobileDTO {
  /// Maps [PayToMobileDTO] into its model.
  PayToMobile toPayToMobile() => PayToMobile(
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
        return PayToMobileRequestType.selfCash;

      case PayToMobileRequestTypeDTO.unknown:
        throw MappingException(
          from: PayToMobileRequestTypeDTO,
          to: PayToMobileRequestType,
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
