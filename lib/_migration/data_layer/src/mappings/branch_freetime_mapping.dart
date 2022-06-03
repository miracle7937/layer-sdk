import '../../models.dart';
import '../dtos.dart';

/// Provide Mappings for [BranchFreeTimeDTO]
extension BranchFreeTimeDTOMapping on BranchFreeTimeDTO {
  /// Maps [BranchFreeTimeDTO] into [BranchFreeTime]
  BranchFreeTime toBranchFreeTime() {
    return BranchFreeTime(
      date: date,
      dayStatus: dayStatus?.toBranchDayStatus() ?? BranchDayStatus.free,
      slotTime: slotTime,
      startTime: startTime,
      stopTime: stopTime,
      value: value ?? [],
    );
  }
}

/// Provide Mappings for [BranchFreeTime]
extension BranchFreeTimeMapping on BranchFreeTime {
  /// Maps [BranchFreeTimeDTO] into [BranchFreeTime]
  BranchFreeTimeDTO toBranchFreeTimeDTO() {
    return BranchFreeTimeDTO(
      date: date,
      dayStatus: dayStatus.toBranchDayStatusDTO(),
      slotTime: slotTime,
      startTime: startTime,
      stopTime: stopTime,
      value: value,
    );
  }
}

/// Provides mapping for [BranchDayStatusDTO]
extension BranchDayStatusDTOMapping on BranchDayStatusDTO {
  /// Maps [BranchDayStatusDTO] int [BranchDayStatus]
  BranchDayStatus toBranchDayStatus() {
    switch (this) {
      case BranchDayStatusDTO.free:
        return BranchDayStatus.free;
      case BranchDayStatusDTO.busy:
        return BranchDayStatus.busy;
      case BranchDayStatusDTO.closed:
        return BranchDayStatus.closed;
      case BranchDayStatusDTO.mixed:
        return BranchDayStatus.mixed;
      default:
        return BranchDayStatus.free;
    }
  }
}

/// Provides mapping for [BranchDayStatus]
extension BranchDayStatusMapping on BranchDayStatus {
  /// Maps [BranchDayStatusDTO] int [BranchDayStatus]
  BranchDayStatusDTO toBranchDayStatusDTO() {
    switch (this) {
      case BranchDayStatus.free:
        return BranchDayStatusDTO.free;
      case BranchDayStatus.closed:
        return BranchDayStatusDTO.busy;
      case BranchDayStatus.closed:
        return BranchDayStatusDTO.closed;
      case BranchDayStatus.mixed:
        return BranchDayStatusDTO.mixed;
      default:
        return BranchDayStatusDTO.free;
    }
  }
}
