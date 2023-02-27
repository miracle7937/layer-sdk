import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [Beneficiary]
extension BeneficiaryMapping on Beneficiary {
  /// Maps into a [AccountDTO]
  BeneficiaryDTO toBeneficiaryDTO() => BeneficiaryDTO(
        beneficiaryId: id,
        nickname: nickname,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        accountNumber: accountNumber?.isEmpty ?? true ? iban : accountNumber,
        routingCode: accountNumber?.isEmpty ?? true ? null : routingCode,
        rcptAddress1: address1,
        rcptAddress2: address2,
        rcptAddress3: address3,
        recipientType: recipientType?.toRecipientTypeDTO(),
        bankSwift: bank?.bic ?? '',
        bankName: bank?.name ?? '',
        bankCountryCode: bank?.countryCode ?? '',
        rcptCountryCode: rcptCountryCode,
        currency: currency,
        otpId: otpId,
        type: type?.toTransferTypeDTO(),
      );
}

/// Extension that provides mappings for [BeneficiaryRecipientType]
extension BeneficiaryRecipientTypeMapping on BeneficiaryRecipientType {
  /// Maps into a [BeneficiaryRecipientTypeDTO]
  BeneficiaryRecipientTypeDTO toRecipientTypeDTO() {
    switch (this) {
      case BeneficiaryRecipientType.business:
        return BeneficiaryRecipientTypeDTO.business;

      case BeneficiaryRecipientType.person:
        return BeneficiaryRecipientTypeDTO.person;
    }
  }
}
