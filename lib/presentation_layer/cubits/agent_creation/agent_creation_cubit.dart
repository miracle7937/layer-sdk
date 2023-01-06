import 'dart:collection';

import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that manages the overall process of creating a new agent.
///
/// It coordinates the work of the steps required to create the agent.
/// Each step should be represented by a cubit extending the `StepCubit` class
/// and set the appropriate properties on the `User` object, that's passed
/// between the steps when continuing.
///
/// The `onContinue` method should be called when finalizing each on the steps,
/// when called on the last step it will make a request to register the agent.

class AgentCreationCubit extends Cubit<AgentCreationState> {
  final RegisterCorporateAgentUseCase _registerAgentUseCase;

  /// The customer for whom the new agent is being created.
  final Customer customer;

  /// List of cubits responsible for each agent's creation step.
  final UnmodifiableListView<StepCubit<NewAgentStepState>> stepsCubits;

  /// If provided then it's edit process.
  final User? editingUser;

  /// Whether it's editing of existing agent or creation of new one.
  bool get isEdit => editingUser != null;

  /// Creates a new instance of [AgentCreationCubit]
  AgentCreationCubit({
    required this.customer,
    required RegisterCorporateAgentUseCase registerAgentUseCase,
    required this.stepsCubits,
    this.editingUser,
  })  : _registerAgentUseCase = registerAgentUseCase,
        super(
          AgentCreationState(
            stepsStatuses: [
              NewAgentStepStatus.current,
              ...List.filled(
                stepsCubits.length - 1,
                NewAgentStepStatus.upcoming,
              ),
            ],
          ),
        );

  /// Handles event of moving to next step if current step is completed.
  Future<void> onContinue() async {
    emit(
      state.copyWith(
        busy: true,
        error: AgentCreationStateError.none,
      ),
    );
    final canContinue = await stepsCubits[state.currentStepIndex].onContinue();
    emit(
      state.copyWith(
        busy: false,
      ),
    );
    if (!canContinue) {
      return;
    }
    if (state.currentStepIndex == stepsCubits.length - 1) {
      var user = User(
        id: isEdit ? editingUser!.id : '',
        customerId: customer.id,
        customerName: customer.fullName,
        username: '',
        firstName: '',
        lastName: '',
        mobileNumber: '',
        email: '',
      );
      for (var stepCubit in stepsCubits) {
        if (stepCubit.user != null) {
          final stepCubitUser = stepCubit.user!;
          user = user.copyWith(
            username: stepCubitUser.username?.isEmpty ?? true
                ? null
                : stepCubitUser.username,
            firstName: stepCubitUser.firstName?.isEmpty ?? true
                ? null
                : stepCubitUser.firstName,
            lastName: stepCubitUser.lastName?.isEmpty ?? true
                ? null
                : stepCubitUser.lastName,
            mobileNumber: stepCubitUser.mobileNumber?.isEmpty ?? true
                ? null
                : stepCubitUser.mobileNumber,
            email: stepCubitUser.email?.isEmpty ?? true
                ? null
                : stepCubitUser.email,
            agentCustomerId: stepCubitUser.agentCustomerId,
            roles: stepCubitUser.roles.isEmpty ? null : stepCubitUser.roles,
            gender: stepCubitUser.gender,
            maritalStatus: stepCubitUser.maritalStatus,
            branch: stepCubitUser.branch,
            dob: stepCubitUser.dob,
            motherName: stepCubitUser.motherName,
            address: stepCubitUser.address,
            visibleCards: stepCubitUser.visibleCards.isEmpty
                ? null
                : stepCubitUser.visibleCards,
            visibleAccounts: stepCubitUser.visibleAccounts.isEmpty
                ? null
                : stepCubitUser.visibleAccounts,
            image: stepCubitUser.image,
          );
        }
      }
      await _register(user: user);
      return;
    }
    final currentStepIndex = state.currentStepIndex + 1;
    final stepsStatuses = statusForNewCurrentIndex(currentStepIndex);
    emit(state.copyWith(
      action: StepsStateAction.continueAction,
      stepsStatuses: stepsStatuses,
      currentStepIndex: currentStepIndex,
    ));
  }

  /// Updates state when returning to previous step.
  void onBack() {
    final currentStepIndex = state.currentStepIndex - 1;
    final stepsStatuses = statusForNewCurrentIndex(currentStepIndex);
    emit(state.copyWith(
      action: StepsStateAction.backAction,
      stepsStatuses: stepsStatuses,
      currentStepIndex: currentStepIndex,
    ));
  }

  /// Returns list of statuses for each step
  /// for provided new [currentStepIndex]
  List<NewAgentStepStatus> statusForNewCurrentIndex(
    int currentStepIndex,
  ) =>
      List.generate(state.stepsStatuses.length, (i) {
        if (i < currentStepIndex) {
          return NewAgentStepStatus.completed;
        } else if (i == currentStepIndex) {
          return NewAgentStepStatus.current;
        } else {
          return stepsCubits[i].state.completed
              ? NewAgentStepStatus.completed
              : NewAgentStepStatus.upcoming;
        }
      });

  /// Handles event when step with [index] is selected.
  /// Selecting a step is possible only if all of the steps preceding it
  /// are completed.
  void changeStep({required int index}) {
    if (index == state.currentStepIndex) {
      return;
    }
    if (index > state.currentStepIndex) {
      for (var i = state.currentStepIndex; i <= index - 1; ++i) {
        if (!stepsCubits[i].state.completed) {
          return;
        }
      }
    }
    final currentStepIndex = index;
    final stepsStatuses = statusForNewCurrentIndex(currentStepIndex);
    emit(state.copyWith(
      action: StepsStateAction.selectAction,
      stepsStatuses: stepsStatuses,
      currentStepIndex: currentStepIndex,
    ));
  }

  /// Creates new agent with provided [user] data.
  Future<void> _register({
    required User user,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        action: StepsStateAction.confirmCompletionAction,
        error: AgentCreationStateError.none,
      ),
    );

    try {
      await _registerAgentUseCase(
        user: user,
        isEditing: isEdit,
      );
      emit(
        state.copyWith(
          busy: false,
          error: AgentCreationStateError.none,
        ),
      );
    } on Exception catch (_) {
      emit(
        state.copyWith(
          busy: false,
          error: AgentCreationStateError.generic,
        ),
      );
    }
  }
}
