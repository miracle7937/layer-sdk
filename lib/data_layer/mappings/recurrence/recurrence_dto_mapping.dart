import '../../../domain_layer/models/recurrence/recurrence.dart';
import '../../dtos/recurrence/recurrence_dto.dart';

/// Extension that provides mappings for [RecurrenceDTO]
extension RecurrenceDTOMapping on RecurrenceDTO {
  /// Maps into a [Recurrence]
  Recurrence toRecurrence() {
    switch (this) {
      case RecurrenceDTO.once:
        return Recurrence.once;

      case RecurrenceDTO.daily:
        return Recurrence.daily;

      case RecurrenceDTO.weekly:
        return Recurrence.weekly;

      case RecurrenceDTO.biweekly:
        return Recurrence.biweekly;

      case RecurrenceDTO.monthly:
        return Recurrence.monthly;

      case RecurrenceDTO.bimonthly:
        return Recurrence.bimonthly;

      case RecurrenceDTO.quarterly:
        return Recurrence.quarterly;

      case RecurrenceDTO.yearly:
        return Recurrence.yearly;

      case RecurrenceDTO.endOfEachMonth:
        return Recurrence.endOfEachMonth;

      default:
        return Recurrence.once;
    }
  }
}

/// Extension that provides mappings for [Recurrence]
extension RecurrenceToDTOMapping on Recurrence {
  /// Maps into a [RecurrenceDTO]
  RecurrenceDTO toRecurrenceDTO() {
    switch (this) {
      case Recurrence.once:
        return RecurrenceDTO.once;

      case Recurrence.daily:
        return RecurrenceDTO.daily;

      case Recurrence.weekly:
        return RecurrenceDTO.weekly;

      case Recurrence.biweekly:
        return RecurrenceDTO.biweekly;

      case Recurrence.monthly:
        return RecurrenceDTO.monthly;

      case Recurrence.bimonthly:
        return RecurrenceDTO.bimonthly;

      case Recurrence.quarterly:
        return RecurrenceDTO.quarterly;

      case Recurrence.yearly:
        return RecurrenceDTO.yearly;

      case Recurrence.endOfEachMonth:
        return RecurrenceDTO.endOfEachMonth;

      default:
        return RecurrenceDTO.once;
    }
  }
}
