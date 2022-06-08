import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

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
