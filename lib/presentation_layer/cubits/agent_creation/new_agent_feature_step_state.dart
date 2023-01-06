import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The state of the [NewAgentFeatureStepCubit]
class NewAgentFeatureStepState extends NewAgentStepState {
  /// List of all selected [Role]s
  final UnmodifiableListView<Role> selectedRoles;

  /// Creates [NewAgentFeatureStepState].
  NewAgentFeatureStepState({
    Iterable<Role> selectedRoles = const [],
    StepsStateAction action = StepsStateAction.none,
    bool completed = false,
    bool busy = false,
  })  : selectedRoles = UnmodifiableListView(selectedRoles),
        super(
          action: action,
          completed: completed,
          busy: busy,
        );

  /// Creates a new state based on this one.
  @override
  NewAgentFeatureStepState copyWith({
    Iterable<Role>? selectedRoles,
    StepsStateAction? action,
    bool? completed,
    bool? busy,
  }) =>
      NewAgentFeatureStepState(
        selectedRoles: selectedRoles ?? this.selectedRoles,
        action: action ?? this.action,
        completed: completed ?? this.completed,
        busy: busy ?? this.busy,
      );

  @override
  List<Object?> get props => [
        action,
        completed,
        busy,
        selectedRoles,
      ];
}
