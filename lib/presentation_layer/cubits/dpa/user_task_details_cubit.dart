import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that manages the user's access level
class UserTaskDetailsCubit extends Cubit<UserTaskDetailsState> {
  final CheckUserTaskUseCase _checkVerificationStepUseCase;

  /// Creates a new cubit using the necessary use cases.
  UserTaskDetailsCubit({
    required CheckUserTaskUseCase checkVerificationStepUseCase,
  })  : _checkVerificationStepUseCase = checkVerificationStepUseCase,
        super(UserTaskDetailsState());

  /// Checks if the customer has a verification in progress
  /// for this step (whether its starting/basic/full access)
  Future<void> checkVerificationStepUseCase({
    required String processKey,
    String? variable,
    String? variableValue,
  }) async {
    emit(
      state.copyWith(
        actions:
            state.addAction(UserTaskDetailsAction.checkingForUserTaskDetails),
        errors: {},
      ),
    );

    try {
      final tasks = await _checkVerificationStepUseCase(
        processKey: processKey,
        variable: variable,
        variableValue: variableValue,
      );

      emit(
        state.copyWith(
          tasks: tasks,
          actions: state
              .removeAction(UserTaskDetailsAction.checkingForUserTaskDetails),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state
              .removeAction(UserTaskDetailsAction.checkingForUserTaskDetails),
          errors: state.addErrorFromException(
            action: UserTaskDetailsAction.checkingForUserTaskDetails,
            exception: e,
          ),
        ),
      );
    }
  }
}
