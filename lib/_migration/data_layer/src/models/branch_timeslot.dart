import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Holds values for timeslots and if they are available
@immutable
class BranchTimeSlot extends Equatable {
  /// Time for the slot
  final DateTime? slotTime;

  /// If is available
  final bool? isAvailable;

  /// Creates a new [BranchTimeSlot]
  BranchTimeSlot({
    this.slotTime,
    this.isAvailable,
  });

  @override
  List<Object?> get props => [
        slotTime,
        isAvailable,
      ];

  @override
  String toString() =>
      'BranchTimeSlot(slotTime: $slotTime, isAvailable: $isAvailable)';
}
