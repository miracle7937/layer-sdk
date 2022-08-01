import '../../models.dart';

/// An interface that provides new transfers to be scheduled.
abstract class NewSchedulableTransfer extends NewTransfer {
  /// The recurrence for the transfer.
  final Recurrence recurrence;

  /// The start date for the scheduled transfer.
  final DateTime? starts;

  /// The end date for the scheduled transfer.
  final DateTime? ends;

  /// Creates a new [NewSchedulableTransfer].
  NewSchedulableTransfer({
    super.type,
    super.source,
    super.amount,
    super.currency,
    super.destination,
    this.recurrence = Recurrence.none,
    this.starts,
    this.ends,
  });

  /// Whether if this transfer is recurring or not.
  bool get isRecurring =>
      recurrence != Recurrence.none || recurrence != Recurrence.once;
}
