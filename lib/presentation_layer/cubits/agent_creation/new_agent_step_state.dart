import 'package:equatable/equatable.dart';

/// The state of the new agent steps cubit
class NewAgentStepState extends Equatable {
  /// Current action.
  final StepsStateAction action;

  /// Whether state is completed.
  final bool completed;

  /// True if the cubit is processing something.
  final bool busy;

  /// Creates a new [NewAgentStepState].
  const NewAgentStepState({
    this.action = StepsStateAction.none,
    this.completed = false,
    this.busy = false,
  });

  @override
  List<Object?> get props => [
        action,
        completed,
        busy,
      ];

  /// Creates a new state based on this one.
  NewAgentStepState copyWith({
    StepsStateAction? action,
    bool? completed,
    bool? busy,
  }) =>
      NewAgentStepState(
        action: action ?? this.action,
        completed: completed ?? this.completed,
        busy: busy ?? this.busy,
      );
}

/// All possible actions for agent's creation process
enum StepsStateAction {
  /// Init action, is used for editing agent, to set initial values.
  initAction,

  /// Returning to previous step action.
  backAction,

  /// Editing current step action.
  editAction,

  /// Moving to next step action.
  continueAction,

  /// Selecting any step action.
  selectAction,

  /// Completion of process action.
  confirmCompletionAction,

  /// No action.
  none,
}
