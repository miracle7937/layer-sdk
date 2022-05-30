import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

/// Class that hold all available timeframes in a specific date,
/// when a branch opens, when it closes, the status of that day
@immutable
class BranchFreeTime extends Equatable {
  /// Selected Date
  final DateTime? date;

  /// Status of the selected day
  final BranchDayStatus dayStatus;

  /// Time slot used in the value matrix
  final int? slotTime;

  /// The first hour available
  final DateTime? startTime;

  /// The last hour available
  final DateTime? stopTime;

  /// A list with the times available during that day
  final List<bool> value;

  /// creates a new instance of [BranchFreeTime]
  BranchFreeTime({
    this.dayStatus = BranchDayStatus.free,
    this.value = const <bool>[],
    this.date,
    this.slotTime,
    this.startTime,
    this.stopTime,
  });

  @override
  List<Object?> get props {
    return [
      date,
      dayStatus,
      slotTime,
      startTime,
      stopTime,
      value,
    ];
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'BranchFreeTime(date: $date, dayStatus: $dayStatus, slotTime: $slotTime, startTime: $startTime, stopTime: $stopTime, value: $value)';
  }

  /// Creates a new [BranchFreeTime]
  BranchFreeTime copyWith({
    DateTime? date,
    BranchDayStatus? dayStatus,
    int? slotTime,
    DateTime? startTime,
    DateTime? stopTime,
    List<bool>? value,
  }) {
    return BranchFreeTime(
      date: date ?? this.date,
      dayStatus: dayStatus ?? this.dayStatus,
      slotTime: slotTime ?? this.slotTime,
      startTime: startTime ?? this.startTime,
      stopTime: stopTime ?? this.stopTime,
      value: value ?? this.value,
    );
  }
}

/// The status of the branch that day
enum BranchDayStatus {
  /// Is a free day
  free,

  /// Is a mixed day
  mixed,

  /// Branch is closed
  closed,

  /// Branch is Busy
  busy,
}
