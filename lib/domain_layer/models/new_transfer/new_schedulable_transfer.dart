import '../../models.dart';

/// An interface that provides new transfers to be scheduled.
abstract class NewSchedulableTransfer extends NewTransfer {
  /// The schedule details.
  final ScheduleDetails scheduleDetails;

  /// Creates a new [NewSchedulableTransfer].
  const NewSchedulableTransfer({
    super.type,
    super.source,
    super.amount,
    super.currency,
    super.destination,
    ScheduleDetails? scheduleDetails,
    super.saveToShortcut,
    super.shortcutName,
    super.note,
    super.transferId,
    super.deviceUID,
  }) : scheduleDetails = scheduleDetails ?? const ScheduleDetails();

  /// Whether if this transfer is recurring or not.
  bool get isRecurring =>
      scheduleDetails.recurrence != Recurrence.none ||
      scheduleDetails.recurrence != Recurrence.once;
}
