import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status.
enum TaskHistoryErrorStatus {
  /// No errors
  none,

  /// Network error
  network,
}

/// The state of the task history.
class TaskHistoryState extends Equatable {
  /// The history list of tasks.
  final UnmodifiableListView<DPATask> tasks;

  /// If this cubit is busy doing some work.
  final bool busy;

  /// The current error status.
  final TaskHistoryErrorStatus errorStatus;

  /// Creates a new [TaskHistoryState].
  TaskHistoryState({
    Iterable<DPATask> tasks = const <DPATask>[],
    this.busy = false,
    this.errorStatus = TaskHistoryErrorStatus.none,
  }) : tasks = UnmodifiableListView(tasks);

  @override
  List<Object?> get props => [
        tasks,
        busy,
        errorStatus,
      ];

  /// Creates a [TaskHistoryState] based on this one.
  TaskHistoryState copyWith({
    Iterable<DPATask>? tasks,
    bool? busy,
    TaskHistoryErrorStatus? errorStatus,
  }) =>
      TaskHistoryState(
        tasks: tasks ?? this.tasks,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
