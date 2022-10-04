import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extensions on [NewPayToMobile].
extension NewPayToMobileExtension on NewPayToMobile {
  /// Maps a [NewPayToMobile] into its DTO.
  NewPayToMobileDTO toDTO() => NewPayToMobileDTO(
        accountId: accountId,
        dialCode: dialCode,
        phoneNumber: phoneNumber,
        currencyCode: currencyCode,
        amount: amount,
        transactionCode: transactionCode,
        requestTypeDTO: requestType?.toDTO(),
      );
}

/// Extensions on [PayToMobileRequestType].
extension PayToMobileRequestTypeExtension on PayToMobileRequestType {
  /// Maps a [PayToMobileRequestType] into its DTO.
  PayToMobileRequestTypeDTO toDTO() {
    switch (this) {
      case PayToMobileRequestType.accountTransfer:
        return PayToMobileRequestTypeDTO.accountTransfer;

      case PayToMobileRequestType.atmCash:
        return PayToMobileRequestTypeDTO.atmCash;

      case PayToMobileRequestType.selfCash:
        return PayToMobileRequestTypeDTO.selfCash;
    }
  }
}
