import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status
enum UserTasksErrorStatus {
  /// No errors
  none,

  /// Network error
  network,
}

/// The available actions
enum UserTasksAction {
  /// No action,
  none,

  /// Finalized a task.
  finalizedTask,
}

/// The state that holds the user's assigned tasks.
class UserTasksState extends Equatable {
  /// The customer id associated with these tasks.
  final String? customerId;

  /// The list of tasks for the logged in user.
  final UnmodifiableListView<DPATask> tasks;

  /// If this cubit is busy doing some work.
  final bool busy;

  /// The current error status.
  final UserTasksErrorStatus errorStatus;

  /// The action that was performed.
  final UserTasksAction action;

  /// Creates a new [UserTasksState].
  UserTasksState({
    this.customerId,
    Iterable<DPATask> tasks = const <DPATask>[],
    this.busy = false,
    this.errorStatus = UserTasksErrorStatus.none,
    this.action = UserTasksAction.none,
  }) : tasks = UnmodifiableListView(tasks);

  @override
  List<Object?> get props => [
        customerId,
        tasks,
        busy,
        errorStatus,
        action,
      ];

  /// Creates a [UserTasksState] based on this one.
  UserTasksState copyWith({
    String? customerId,
    Iterable<DPATask>? tasks,
    bool? busy,
    UserTasksErrorStatus? errorStatus,
    UserTasksAction? action,
  }) =>
      UserTasksState(
        customerId: customerId ?? this.customerId,
        tasks: tasks ?? this.tasks,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
        action: action ?? this.action,
      );
}
