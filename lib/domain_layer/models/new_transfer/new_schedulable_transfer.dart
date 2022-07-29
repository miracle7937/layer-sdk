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
    TransferType? type,
    NewTransferSource? source,
    double? amount,
    Currency? currency,
    NewTransferDestination? destination,
    this.recurrence = Recurrence.none,
    this.starts,
    this.ends,
  }) : super(
          type: type,
          source: source,
          amount: amount,
          currency: currency,
          destination: destination,
        );

  /// Whether if this transfer is recurring or not.
  bool get isRecurring =>
      recurrence != Recurrence.none || recurrence != Recurrence.once;
}
