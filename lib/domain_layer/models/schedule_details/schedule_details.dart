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
      startDate = _calculateStartDate(startDate);

      endDate = _calculateEndDate(
        recurrence ?? this.recurrence,
        executions,
        startDate,
      );
    } else if (endDate != null) {
      /// The end date changed, calculates the executions and adjust the
      /// end date to the correct one.
      startDate = _calculateStartDate(startDate);

      executions = calculateRecurrenceExecutions(
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
      startDate = _calculateStartDate(startDate);

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

  DateTime _calculateStartDate(
    DateTime? startDate,
  ) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    return startDate != null
        ? startDate
        : this.startDate ??
            (recurrence == Recurrence.endOfEachMonth
                ? DateTime(
                    now.year,
                    now.month + 1,
                    1,
                  ).subtract(const Duration(days: 1))
                : tomorrow);
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
          startDate.day + executions - 1,
        );

      case Recurrence.monthly:
        return DateTime(
          startDate.year,
          startDate.month + executions - 1,
          startDate.day,
        );

      case Recurrence.yearly:
        return DateTime(
          startDate.year + executions - 1,
          startDate.month,
          startDate.day,
        );

      case Recurrence.weekly:
        return DateTime(
          startDate.year,
          startDate.month,
          startDate.day + 7 * (executions - 1),
        );

      case Recurrence.biweekly:
        return DateTime(
          startDate.year,
          startDate.month,
          startDate.day + 14 * (executions - 1),
        );

      case Recurrence.quarterly:
        return DateTime(
          startDate.year,
          startDate.month + 3 * (executions - 1),
          startDate.day,
        );

      case Recurrence.bimonthly:
        return DateTime(
          startDate.year,
          startDate.month + 2 * (executions - 1),
          startDate.day,
        );

      case Recurrence.endOfEachMonth:
        return DateTime(
          startDate.year,
          startDate.month + executions,
          1,
        ).subtract(const Duration(days: 1));

      default:
        throw Exception('unsupported recurrence on _calculateEndDate');
    }
  }

  /// Calculates the amount of executions between the start and the end dates
  /// depending on the recurrence.
  int calculateRecurrenceExecutions(
    Recurrence recurrence,
    DateTime startDate,
    DateTime endDate,
  ) {
    final timeBetweenStartAndEndDates = startDate.difference(endDate).abs();
    var executions = 0;

    switch (recurrence) {
      case Recurrence.daily:
        executions = timeBetweenStartAndEndDates.inDays + 1;
        break;

      case Recurrence.weekly:
        executions = (timeBetweenStartAndEndDates.inDays / 7).floor() + 1;
        break;

      case Recurrence.biweekly:
        executions = (timeBetweenStartAndEndDates.inDays / 14).floor() + 1;
        break;

      case Recurrence.monthly:
      case Recurrence.yearly:
      case Recurrence.quarterly:
      case Recurrence.bimonthly:
      case Recurrence.endOfEachMonth:
        final firstExecutionDate = _calculateEndDate(
          recurrence,
          2,
          startDate,
        );
        var firstExecutionTime = startDate.difference(firstExecutionDate).abs();

        executions =
            (timeBetweenStartAndEndDates.inDays / firstExecutionTime.inDays)
                    .floor() +
                1;
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
