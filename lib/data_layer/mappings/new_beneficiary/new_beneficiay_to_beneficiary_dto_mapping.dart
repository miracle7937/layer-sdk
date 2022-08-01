import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Mapping extension for the [NewBeneficiary].
extension NewBeneficiaryToBeneficiaryDTOExtension on NewBeneficiary {
  /// Maps a [NewBeneficiary] into a [BeneficiaryDTO].
  BeneficiaryDTO toBeneficiaryDTO() => BeneficiaryDTO(
        nickname: nickname,
        firstName: firstName,
        lastName: lastName,
        currency: currency?.code,
        accountNumber: ibanOrAccountNO,
        routingCode: sortCode,
        type: bank?.transferType?.toTransferTypeDTO(),
        rcptCountryCode: country?.countryCode,
        bankName: bank?.name,
        bankSwift: bank?.bic,
        bankCountryCode: bank?.country?.countryCode,
        bankAddress1: bank?.address1,
        bankAddress2: bank?.address2,
        bankImageUrl: bank?.imageUrl,
      );
}
