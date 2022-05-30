import 'dart:collection';

import 'package:equatable/equatable.dart';
import '../../../../data_layer/data_layer.dart';

/// Signals when an action was executed.
enum UnassignedTasksAction {
  /// No action was taken.
  none,

  /// Claimed tasks for the user.
  claimed,
}

/// The available error status
enum UnassignedTasksErrorStatus {
  /// No errors
  none,

  /// Network error
  network,
}

/// The state of the unassigned tasks
class UnassignedTasksState extends Equatable {
  /// The list of unassigned tasks.
  final UnmodifiableListView<DPATask> tasks;

  /// If this cubit is busy doing some work.
  final bool busy;

  /// The current error status.
  final UnassignedTasksErrorStatus errorStatus;

  /// The current executed action.
  final UnassignedTasksAction action;

  /// The optional customer id associated with these tasks.
  final String? customerId;

  /// Creates a new [UnassignedTasksState].
  UnassignedTasksState({
    this.customerId,
    Iterable<DPATask> tasks = const <DPATask>[],
    this.busy = false,
    this.action = UnassignedTasksAction.none,
    this.errorStatus = UnassignedTasksErrorStatus.none,
  }) : tasks = UnmodifiableListView(tasks);

  @override
  List<Object?> get props => [
        customerId,
        tasks,
        busy,
        action,
        errorStatus,
      ];

  /// Creates a [UnassignedTasksState] based on this one.
  UnassignedTasksState copyWith({
    String? customerId,
    Iterable<DPATask>? tasks,
    bool? busy,
    UnassignedTasksAction? action,
    UnassignedTasksErrorStatus? errorStatus,
  }) =>
      UnassignedTasksState(
        customerId: customerId ?? this.customerId,
        tasks: tasks ?? this.tasks,
        busy: busy ?? this.busy,
        action: action ?? this.action,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
