import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that helps parsin [MandateDTO]
extension MandateDTOMapper on MandateDTO {
  /// Parses a [MandateDTO] into a [Mandate]
  Mandate toMandate() {
    return Mandate(
      mandateId: mandateId ?? 0,
      fromAccount: fromAccount ?? '',
      fromCard: fromCard ?? '',
      reference: reference ?? '',
      mandateStatus: mandateStatus?.toMandateStatus() ?? MandateStatus.unknown,
      bankMandateId: bankMandateId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension that helps parsing [MandateStatusDTO]
extension MandateStatusDTOMapper on MandateStatusDTO {
  /// Parses a [MandateStatusDTO] into a [MandateStatus]
  MandateStatus toMandateStatus() {
    switch (this) {
      case MandateStatusDTO.active:
        return MandateStatus.active;
      case MandateStatusDTO.pending:
        return MandateStatus.pending;
      case MandateStatusDTO.rejecting:
        return MandateStatus.rejecting;
      case MandateStatusDTO.cancelling:
        return MandateStatus.cancelling;
      case MandateStatusDTO.cancelled:
        return MandateStatus.cancelled;
      case MandateStatusDTO.rejected:
        return MandateStatus.rejected;
      default:
        return MandateStatus.unknown;
    }
  }
}
