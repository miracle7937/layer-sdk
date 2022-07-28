import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [Beneficiary]
extension BeneficiaryMapping on Beneficiary {
  /// Maps into a [AccountDTO]
  BeneficiaryDTO toBeneficiaryDTO() => BeneficiaryDTO(
        beneficiaryId: id,
        nickname: nickname,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        accountNumber: accountNumber,
        routingCode: sortCode,
        rcptAddress1: address1,
        rcptAddress2: address2,
        rcptAddress3: address3,
        // status: status?.toBeneficiaryStatus(),
        // type: type?.toTransferType(),
        bankSwift: bank?.bic ?? '',
        bankName: bank?.name ?? '',
        bankCountryCode: bank?.countryCode ?? '',
        currency: currency,
      );
}
