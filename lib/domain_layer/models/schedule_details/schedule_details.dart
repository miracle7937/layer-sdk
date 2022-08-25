import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Model representing the schedule details for an activity.
class ScheduleDetails extends Equatable {
  /// The schedule details recurrence.
  ///
  /// Default is [Recurrence.none].
  final Recurrence recurrence;

  /// The start date.
  final DateTime? startDate;

  /// The end date.
  final DateTime? endDate;

  /// The number of executions.
  final int? executions;

  /// Creates a new [ScheduleDetails].
  const ScheduleDetails({
    this.recurrence = Recurrence.none,
    this.startDate,
    this.endDate,
    this.executions,
  });

  /// TODO: There is to much logic on this method,
  /// let's divide this to a use case when we have time to solve
  /// the tech deb.
  ///
  /// Creates a copy with the passed parameters.
  ScheduleDetails copyWith({
    Recurrence? recurrence,
    DateTime? startDate,
    DateTime? endDate,
    int? executions,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (recurrence != null &&
        [Recurrence.none, Recurrence.once].contains(recurrence)) {
      /// Resets the dates and executions.
      return ScheduleDetails(
        recurrence: recurrence,
        startDate: null,
        endDate: null,
        executions: null,
      );
    }

    if (executions != null) {
      /// The executions changed, calculates the end date.
      startDate ??= this.startDate ?? today;

      endDate = _calculateEndDate(
        recurrence ?? this.recurrence,
        executions,
        startDate,
      );
    } else if (endDate != null) {
      /// The end date changed, calculates the executions and adjust the
      /// end date to the correct one.
      startDate ??= this.startDate ?? today;

      executions = calculateReccurenceExecutions(
        recurrence ?? this.recurrence,
        startDate,
        endDate,
      );

      endDate = _calculateEndDate(
        recurrence ?? this.recurrence,
        executions,
        startDate,
      );
    } else if (this.endDate != null &&
        recurrence != null &&
        recurrence != this.recurrence &&
        this.executions != null) {
      /// The recurrence changed and the end date and executions were already
      /// set. Adjusts the end date.
      startDate ??= this.startDate ?? today;

      endDate = _calculateEndDate(
        recurrence,
        this.executions!,
        startDate,
      );
    }

    return ScheduleDetails(
      recurrence: recurrence ?? this.recurrence,
      startDate: startDate ?? this.startDate,
      endDate: recurrence == Recurrence.once ? null : endDate ?? this.endDate,
      executions:
          recurrence == Recurrence.once ? null : executions ?? this.executions,
    );
  }

  /// Returns the end date calculated by the passed values.
  DateTime _calculateEndDate(
    Recurrence recurrence,
    int executions,
    DateTime startDate,
  ) {
    switch (recurrence) {
      case Recurrence.daily:
        return DateTime(
          startDate.year,
          startDate.month,
          startDate.day + executions,
        );

      case Recurrence.monthly:
        return DateTime(
          startDate.year,
          startDate.month + executions,
          startDate.day,
        );

      case Recurrence.yearly:
        return DateTime(
          startDate.year + executions,
          startDate.month,
          startDate.day,
        );

      case Recurrence.weekly:
        return DateTime(
          startDate.year,
          startDate.month,
          startDate.day + 7 * executions,
        );

      case Recurrence.biweekly:
        return DateTime(
          startDate.year,
          startDate.month,
          startDate.day + 14 * executions,
        );

      case Recurrence.quarterly:
        return DateTime(
          startDate.year,
          startDate.month + 3 * executions,
          startDate.day,
        );

      case Recurrence.bimonthly:
        return DateTime(
          startDate.year,
          startDate.month + 2 * executions,
          startDate.day,
        );

      case Recurrence.endOfEachMonth:
        return DateTime(
          startDate.year,
          startDate.month + executions,
          1,
        );

      default:
        throw Exception('unsupported recurrence on _calculateEndDate');
    }
  }

  /// Calculates the amount of executions between the start and the end dates
  /// depending on the recurrence.
  int calculateReccurenceExecutions(
    Recurrence recurrence,
    DateTime startDate,
    DateTime endDate,
  ) {
    final timeBetweenStartAndEndDates = startDate.difference(endDate).abs();
    var executions = 0;

    switch (recurrence) {
      case Recurrence.daily:
        executions = timeBetweenStartAndEndDates.inDays;
        break;

      case Recurrence.weekly:
        executions = (timeBetweenStartAndEndDates.inDays / 7).floor();
        break;

      case Recurrence.biweekly:
        executions = (timeBetweenStartAndEndDates.inDays / 14).floor();
        break;

      case Recurrence.monthly:
      case Recurrence.yearly:
      case Recurrence.quarterly:
      case Recurrence.bimonthly:
      case Recurrence.endOfEachMonth:
        final firstExecutionDate = _calculateEndDate(
          recurrence,
          1,
          startDate,
        );
        final firstExecutionTime =
            startDate.difference(firstExecutionDate).abs();

        executions =
            (timeBetweenStartAndEndDates.inDays / firstExecutionTime.inDays)
                .floor();
        break;

      default:
        throw Exception('unsupported recurrence on _calculateEndDate');
    }

    if (executions == 0) {
      executions = 1;
    }

    return executions;
  }

  @override
  List<Object?> get props => [
        recurrence,
        startDate,
        endDate,
        executions,
      ];
}
