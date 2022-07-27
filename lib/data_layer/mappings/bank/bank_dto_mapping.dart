import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [BankDTO]
extension BankDTOMapping on BankDTO {
  /// Maps into a [Bank]
  Bank toBank() => Bank(
        bic: bic,
        name: name,
        address1: address1,
        address2: address2,
        countryCode: countryCode,
        created: created,
        updated: updated,
        country: country?.toCountry(),
        transferType: transferType?.toTransferType(),
        imageUrl: imageUrl,
        category: category,
        code: code,
        branchCode: branchCode,
        branchName: branchName,
      );
}
