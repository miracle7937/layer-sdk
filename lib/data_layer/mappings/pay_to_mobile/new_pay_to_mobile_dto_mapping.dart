import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extensions on [NewPayToMobile].
extension NewPayToMobileExtension on NewPayToMobile {
  /// Maps a [NewPayToMobile] into its DTO.
  NewPayToMobileDTO toDTO() => NewPayToMobileDTO(
        accountId: accountId,
        dialCode: dialCode ?? '',
        phoneNumber: phoneNumber,
        currencyCode: currencyCode,
        amount: amount,
        transactionCode: transactionCode,
        requestTypeDTO: requestType?.toRequestTypeDTO(),
      );
}
