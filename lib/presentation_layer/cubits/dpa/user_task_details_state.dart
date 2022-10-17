import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the actions that can be performed by [UserTaskDetailsCubit]
enum UserTaskDetailsAction {
  /// Busy checking if task is in progress
  checkingForUserTaskDetails,
}

/// Represents the error codes that can be returned by [UserTaskDetailsCubit]
enum UserTaskDetailsErrorCode {
  /// Network error
  network,

  /// Generic error
  generic
}

/// Represents the state of [UserTaskDetailsCubit]
class UserTaskDetailsState
    extends BaseState<UserTaskDetailsAction, void, UserTaskDetailsErrorCode> {
  /// List of [DPATask] of the customer
  final UnmodifiableListView<DPATask> tasks;

  /// Creates a new instance of [UserTaskDetailsState]
  UserTaskDetailsState({
    Iterable<DPATask> tasks = const [],
    super.actions = const <UserTaskDetailsAction>{},
    super.events = const <void>{},
    super.errors = const <CubitError>{},
  }) : tasks = UnmodifiableListView(tasks);

  @override
  List<Object?> get props => [
        tasks,
        actions,
        events,
        errors,
      ];

  /// Creates a new instance of [UserTaskDetailsState] based
  /// on the current instance
  UserTaskDetailsState copyWith({
    Iterable<DPATask>? tasks,
    Set<UserTaskDetailsAction>? actions,
    Set<CubitError>? errors,
  }) {
    return UserTaskDetailsState(
      tasks: tasks ?? this.tasks,
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
    );
  }
}
