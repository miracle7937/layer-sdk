import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/strategies.dart';

/// A state representing the progress in the registration process.
class RegistrationState extends Equatable {
  /// True when cubits performs an operation.
  final bool busy;

  /// The index of the current registration step.
  final int currentStep;

  /// The form data validation errors that should be presented to the user.
  ///
  /// The values are keys of the container messages to be displayed.
  final UnmodifiableMapView<RegistrationInputType,
      RegistrationFormValidationError> formErrors;

  /// The state of an error that could be thrown when performing the current
  /// step.
  final RegistrationStateError stepError;

  /// The message of an error thrown when performing the current step
  /// to be displayed to the user.
  ///
  /// It's possible for an error to be thrown without an user presentable
  /// message, in that case the [stepError] will be set to an error state,
  /// but the [stepErrorMessage] will be null.
  final String? stepErrorMessage;

  /// The current state of the parameters for the current step.
  // TODO: What if the flow allows to jump between steps?
  // We should keep the data, maybe we could have a Map<RegistrationStep<T>, T>?
  final dynamic currentParameters;

  /// True when the current step is valid and ready to be performed.
  final bool stepValid;

  /// Creates [RegistrationState].
  RegistrationState({
    this.busy = false,
    this.currentStep = 0,
    Map<RegistrationInputType, RegistrationFormValidationError> formErrors =
        const {},
    this.stepError = RegistrationStateError.none,
    this.stepErrorMessage,
    this.currentParameters,
    this.stepValid = false,
  }) : formErrors = UnmodifiableMapView(formErrors);

  /// Returns a new [RegistrationState] modified by provided values.
  RegistrationState copyWith({
    bool? busy,
    int? currentStep,
    Map<RegistrationInputType, RegistrationFormValidationError>? formErrors,
    RegistrationStateError? stepError,
    String? stepErrorMessage,
    dynamic currentParameters,
    bool? stepValid,
  }) =>
      RegistrationState(
        busy: busy ?? this.busy,
        currentStep: currentStep ?? this.currentStep,
        formErrors: formErrors ?? this.formErrors,
        stepError: stepError ?? this.stepError,
        stepErrorMessage: stepError == RegistrationStateError.none
            ? null
            : stepErrorMessage ?? this.stepErrorMessage,
        currentParameters: currentParameters ?? this.currentParameters,
        stepValid: stepValid ?? this.stepValid,
      );

  @override
  List<Object?> get props => [
        busy,
        currentStep,
        formErrors,
        stepError,
        stepErrorMessage,
        currentParameters,
        stepValid,
      ];
}

/// An enum that defines possible error states for the [RegistrationState]
enum RegistrationStateError {
  /// There is no error.
  none,

  /// A generic error happened.
  generic,
}
