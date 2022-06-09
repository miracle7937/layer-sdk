import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mappings for [DPAStatus].
extension DPAStatusMapping on DPAStatus {
  /// Maps into a [DPAStatusDTO].
  DPAStatusDTO toDPAStatusDTO() {
    switch (this) {
      case DPAStatus.active:
        return DPAStatusDTO.active;

      case DPAStatus.pendingUserApproval:
        return DPAStatusDTO.active;

      case DPAStatus.pendingBankApproval:
        return DPAStatusDTO.pendingBankApproval;

      case DPAStatus.completed:
        return DPAStatusDTO.completed;

      case DPAStatus.editRequested:
        return DPAStatusDTO.editRequested;

      case DPAStatus.cancelled:
        return DPAStatusDTO.cancelled;

      case DPAStatus.rejected:
        return DPAStatusDTO.rejected;

      case DPAStatus.failed:
        return DPAStatusDTO.failed;

      default:
        throw MappingException(from: DPAStatus, to: DPAStatusDTO);
    }
  }
}

/// Extension that provides mappings for [DPAStatusDTO].
extension DPAStatusDTOMapping on DPAStatusDTO {
  /// Maps into a [DPAStatus].
  DPAStatus toDPAStatus() {
    switch (this) {
      case DPAStatusDTO.all: // For now, think of all as active.
      case DPAStatusDTO.active:
        return DPAStatus.active;

      case DPAStatusDTO.pendingOtherUserApproval:
        return DPAStatus.pendingUserApproval;

      case DPAStatusDTO.pendingBankApproval:
        return DPAStatus.pendingBankApproval;

      case DPAStatusDTO.completed:
        return DPAStatus.completed;

      case DPAStatusDTO.editRequested:
        return DPAStatus.editRequested;

      case DPAStatusDTO.cancelled:
        return DPAStatus.cancelled;

      case DPAStatusDTO.rejected:
        return DPAStatus.rejected;

      case DPAStatusDTO.failed:
        return DPAStatus.failed;

      default:
        throw MappingException(from: DPAStatusDTO, to: DPAStatus);
    }
  }
}
