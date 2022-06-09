import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [BeneficiaryDTO]
extension BeneficiaryDTOMapping on BeneficiaryDTO {
  /// Maps into a [Beneficiary]
  Beneficiary toBeneficiary() => Beneficiary(
        id: beneficiaryId,
        nickname: nickname ?? '',
        firstName: firstName ?? '',
        middleName: middleName ?? '',
        accountNumber: accountNumber,
        status: status?.toBeneficiaryStatus(),
        type: type?.toTransferType(),
        lastName: lastName ?? '',
        bankName: bankName ?? '',
        bankCountryCode: bankCountryCode,
        currency: currency,
      );
}

/// Extension that provides mappings for [BeneficiaryDTOStatus]
extension BeneficiaryDTOStatusMapping on BeneficiaryDTOStatus {
  /// Maps into a [BeneficiaryStatus]
  BeneficiaryStatus toBeneficiaryStatus() {
    switch (this) {
      case BeneficiaryDTOStatus.active:
        return BeneficiaryStatus.active;

      case BeneficiaryDTOStatus.pending:
        return BeneficiaryStatus.pending;

      case BeneficiaryDTOStatus.deleted:
        return BeneficiaryStatus.deleted;

      case BeneficiaryDTOStatus.rejected:
        return BeneficiaryStatus.rejected;

      case BeneficiaryDTOStatus.otp:
        return BeneficiaryStatus.otp;

      case BeneficiaryDTOStatus.system:
        return BeneficiaryStatus.system;

      default:
        throw MappingException(
          from: BeneficiaryDTOStatus,
          to: BeneficiaryStatus,
        );
    }
  }
}
