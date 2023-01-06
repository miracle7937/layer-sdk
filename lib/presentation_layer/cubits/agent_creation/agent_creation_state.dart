import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../cubits.dart';

/// The state of the new agent creation and steps cubit
class AgentCreationState extends Equatable {
  /// Current action.
  final StepsStateAction action;

  /// Index of currently selected step
  final int currentStepIndex;

  /// The list of statuses of each step.
  final UnmodifiableListView<NewAgentStepStatus> stepsStatuses;

  /// True if the cubit is processing something.
  final bool busy;

  /// The last occurred error
  final AgentCreationStateError error;

  /// Creates a new [AgentCreationState].
  AgentCreationState({
    this.action = StepsStateAction.none,
    this.currentStepIndex = 0,
    Iterable<NewAgentStepStatus> stepsStatuses = const [],
    this.busy = false,
    this.error = AgentCreationStateError.none,
  }) : stepsStatuses = UnmodifiableListView(stepsStatuses);

  /// Creates a new state based on this one.
  AgentCreationState copyWith({
    StepsStateAction? action,
    int? currentStepIndex,
    Iterable<NewAgentStepStatus>? stepsStatuses,
    bool? busy,
    AgentCreationStateError? error,
  }) =>
      AgentCreationState(
        action: action ?? this.action,
        currentStepIndex: currentStepIndex ?? this.currentStepIndex,
        stepsStatuses: stepsStatuses ?? this.stepsStatuses,
        busy: busy ?? this.busy,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        action,
        currentStepIndex,
        stepsStatuses,
        busy,
        error,
      ];
}

/// All possible statuses for agent's creation steps
enum NewAgentStepStatus {
  /// Current step.
  current,

  /// Completed step.
  completed,

  /// Upcoming step.
  upcoming,
}

/// All possible errors for [AgentCreationState]
enum AgentCreationStateError {
  /// No error
  none,

  /// Generic error
  generic,
}
