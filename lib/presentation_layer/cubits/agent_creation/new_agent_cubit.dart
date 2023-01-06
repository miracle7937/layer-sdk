import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';

/// An interface representing a single step of the agent's registration process.
abstract class StepCubit<NewAgentStepState> extends Cubit<NewAgentStepState> {
  /// Creates [StepCubit].
  StepCubit(
    NewAgentStepState initialState, {
    User? user,
  })  : _user = user,
        super(initialState);

  /// The user representing corporate customer's agent.
  /// If passed, then agent is being edited.
  final User? _user;

  /// Whether it's editing of existing agent or creation of new one.
  bool get isEdit => _user != null;

  /// Getter for user.
  User? get user => _user;

  /// Continue event handler.
  /// Returns `true` if process can be moved to next step.
  Future<bool> onContinue();
}
