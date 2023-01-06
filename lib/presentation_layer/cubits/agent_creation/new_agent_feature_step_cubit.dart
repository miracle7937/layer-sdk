import 'dart:async';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// A cubit responsible for feature step of Agent's creation process.
class NewAgentFeatureStepCubit extends StepCubit<NewAgentFeatureStepState> {
  @override
  User get user => User(
        id: '',
        roles: state.selectedRoles.map((role) => role.roleId),
      );

  /// Creates new [NewAgentFeatureStepCubit].
  NewAgentFeatureStepCubit({
    User? user,
  }) : super(
          NewAgentFeatureStepState(),
          user: user,
        );

  /// Emits the initial selected roles.
  void initialize({
    required List<Role> roles,
  }) {
    if (super.user != null) {
      final selectedRoles = roles.where(
        (element) => super.user!.roles.contains(
              element.roleId,
            ),
      );
      emit(state.copyWith(
        selectedRoles: selectedRoles,
      ));
    }
  }

  /// Handles event of selecting the [Role]
  void onRoleTap(Role role) => emit(state.copyWith(
        selectedRoles: state.selectedRoles.contains(role)
            ? (state.selectedRoles.toList()..remove(role))
            : (state.selectedRoles.toList()..add(role)),
        action: StepsStateAction.editAction,
      ));

  @override
  Future<bool> onContinue() {
    emit(
      state.copyWith(
        action: StepsStateAction.continueAction,
        completed: true,
      ),
    );
    return Future.value(true);
  }
}
