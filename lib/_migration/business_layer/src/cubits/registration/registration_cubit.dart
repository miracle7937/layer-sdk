import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../../data_layer/repositories.dart';
import '../../cubits.dart';
import '../../errors.dart';
import '../../resources.dart';
import '../../strategies.dart';

/// A cubit that encapsulates the logic related to the registration.
///
/// The registration process is separated into steps. Each step should
/// extend the [RegistrationStep] class. This allows us to configure
/// a different registration process in different apps.
///
/// For example for a simple flow that takes the user cards details
/// and asks him to enter an OTP you might use:
/// ```
/// RegistrationCubit(
///   registrationSteps: [
///     CardDetailsRegistrationStep<MobileAndCardRegistrationParameters>(
///       encryptionStrategy: MobileAndCardRegistrationEncryptionStrategy(
///         encryptionKey: encryptionKey,
///       ),
///       repository: repository,
///     ),
///     OTPRegistrationStep(
///       repository: repository,
///     ),
///   ],
///   formValidationStrategies: [
///     NotEmptyRegistrationValidationStrategy(),
///   ],
///   stepValidationStrategies: [
///     MobileAndCardStepValidationStrategy(),
///   ],
/// );
/// ```
class RegistrationCubit extends Cubit<RegistrationState> {
  /// The steps the define the registration process.
  // TODO: improve the way that steps can pass their results between each other
  final List<RegistrationStep> registrationSteps;

  /// The validation strategies for the registration steps.
  // TODO: Rethink and refactor the registration validation.
  // The step validation will probably need do the same things
  // that the form strategy does but for all fields.
  final List<RegistrationStepValidationStrategy> stepValidationStrategies;

  /// Validation strategies to be used for validating form data
  /// with the [validateFormField] method.
  final List<RegistrationFormValidationStrategy> formValidationStrategies;

  /// The repository used for 2FA.
  final SecondFactorRepository secondFactorRepository;

  /// Creates [RegistrationCubit].
  RegistrationCubit({
    required this.registrationSteps,
    required this.stepValidationStrategies,
    required this.formValidationStrategies,
    required this.secondFactorRepository,
  }) : super(RegistrationState());

  /// Calls the current [RegistrationStep].
  ///
  /// Emits a busy state to indicate that some work is being done
  /// and emits state returned by the current step after it completes.
  ///
  /// Clears the step error in the state.
  ///
  /// If no parameters are provided the parameters from the current state
  /// will be used.
  Future<void> performCurrentStep([dynamic parameters]) async {
    assert(state.currentStep < registrationSteps.length);

    emit(
      state.copyWith(
        busy: true,
        stepError: RegistrationStateError.none,
      ),
    );

    final step = registrationSteps[state.currentStep];

    final newState = await step(
      parameters: parameters ?? state.currentParameters,
      state: state,
    );

    emit(newState.copyWith(busy: false));
  }

  /// Emits the state with updated parameters for the current step
  /// and `stepValid` set to true if the step is ready to be performed.
  ///
  /// The step is considered valid if no applicable
  /// [RegistrationStepValidationStrategy] is found.
  void updateCurrentParameters(dynamic parameters) {
    final step = registrationSteps[state.currentStep];
    final stepValidationStrategy = stepValidationStrategies.firstWhereOrNull(
      (strategy) => strategy.isApplicable(step),
    );
    var stepValid = stepValidationStrategy != null
        ? stepValidationStrategy.validate(parameters)
        : true;

    emit(state.copyWith(
      currentParameters: parameters,
      stepValid: stepValid,
    ));
  }

  /// Emits a state with a current step decremented.
  ///
  /// In most cases current parameters will also need to be updated
  /// with [updateCurrentParameters] method.
  void backToPreviousStep() {
    assert(state.currentStep > 0);
    emit(state.copyWith(
      currentStep: state.currentStep - 1,
    ));
  }

  /// Validates the provided value using available [formValidationStrategies].
  ///
  /// Throws [NoApplicableStrategyError] if no applicable strategy is available.
  ///
  /// Emits a state that will contain updated form errors.
  Future<void> validateFormField<T>({
    required RegistrationInputType type,
    T? value,
  }) async {
    final strategy = formValidationStrategies.firstWhere(
      (element) => element.isApplicable(type),
      orElse: () => throw NoApplicableStrategyError(
        value: value,
        availableStrategies: formValidationStrategies,
      ),
    );

    final error = strategy.validate(value);

    final newFormErrors =
        Map<RegistrationInputType, RegistrationFormValidationError>.from(
      state.formErrors,
    );
    if (error != RegistrationFormValidationError.none) {
      newFormErrors[type] = error;
    } else {
      newFormErrors.remove(type);
    }

    emit(state.copyWith(
      formErrors: newFormErrors,
    ));
  }

  /// Resends the registration OTP.
  // TODO: this does not fit at all with the "steps" idea for the registration.
  // What is the clean way to do that?
  Future<void> resendOTP({
    required int otpId,
    required String token,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        stepError: RegistrationStateError.none,
      ),
    );

    try {
      await secondFactorRepository.resendCustomerOTP(
        otpId: otpId,
        token: token,
      );

      emit(
        state.copyWith(
          busy: false,
        ),
      );
    } on NetException catch (e) {
      emit(
        state.copyWith(
          stepError: RegistrationStateError.generic,
          stepErrorMessage: e.message,
        ),
      );
    }
  }
}
