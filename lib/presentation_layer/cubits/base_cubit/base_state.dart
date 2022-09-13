import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../data_layer/network.dart';

/// The error types that can occur inside a cubit.
enum CubitErrorType {
  /// Generic error.
  generic,

  /// Error thrown by the API.
  api,

  /// Connecitivty error.
  connectivity,

  /// Custom error.
  custom,

  /// Validation.
  validation,
}

/// The error codes that can occur inside a cubit.
enum CubitErrorCode {
  /// Insuficient balance.
  insuficientBalance,

  /// Incorrect OTP code.
  incorrectOTPCode,

  /// The transfer failed.
  transferFailed,
}

/// The base abstract error class.
///
/// All cubit errors should extend this.
abstract class CubitError extends Equatable {
  /// The error type.
  final CubitErrorType type;

  /// Creates a new [CubitError].
  CubitError({
    required this.type,
  });
}

/// Cubit error representing a connectivity error.
class CubitConnectivityError<CubitAction> extends CubitError {
  /// The action that the cubit was performing when the error occurred .
  final CubitAction action;

  /// Creates a new [CubitConnectivityError].
  CubitConnectivityError({
    required this.action,
  }) : super(type: CubitErrorType.connectivity);

  @override
  List<Object?> get props => [
        type,
        action,
      ];
}

/// Cubit error representing an API error.
class CubitAPIError<CubitAction> extends CubitError {
  /// The action that the cubit was performing when the error occurred .
  final CubitAction action;

  /// The optional error code.
  final CubitErrorCode? code;

  /// The optinal error message.
  final String? message;

  /// Creates a new [CubitAPIError].
  CubitAPIError({
    required this.action,
    this.code,
    this.message,
  }) : super(type: CubitErrorType.api);

  @override
  List<Object?> get props => [
        type,
        action,
        code,
        message,
      ];
}

/// Cubit error representing a connectivity error.
class CubitValidationError<ValidationErrorCode> extends CubitError {
  /// The validation error code.
  final ValidationErrorCode validationErrorCode;

  /// Creates a new [CubitConnectivityError].
  CubitValidationError({
    required this.validationErrorCode,
  }) : super(type: CubitErrorType.validation);

  @override
  List<Object?> get props => [
        type,
        validationErrorCode,
      ];
}

/// Cubit error representing a custom error.
class CubitCustomError<CubitAction> extends CubitError {
  /// The action that the cubit was performing when the error occurred .
  final CubitAction? action;

  /// The optional error code.
  final CubitErrorCode? code;

  /// The optinal error message.
  final String? message;

  /// Creates a new [CubitCustomError].
  CubitCustomError({
    this.action,
    this.code,
    this.message,
  }) : super(type: CubitErrorType.custom);

  @override
  List<Object?> get props => [
        type,
        action,
        code,
        message,
      ];
}

/// Interface for all the cubit states.
///
/// It unifies the way of handling:
///   - Busy actions
///   - Error handling
///   - Events
abstract class BaseState<CubitAction, CubitEvent, ValidationErrorCode>
    extends Equatable {
  /// The actions that the cubit is performing.
  final UnmodifiableSetView<CubitAction> actions;

  /// The cubit errors.
  final UnmodifiableSetView<CubitError> errors;

  /// The events that the cubit has emitted for the UI to perform.
  final UnmodifiableSetView<CubitEvent> events;

  /// Creates a new [BaseState].
  BaseState({
    Set<CubitAction>? actions,
    Set<CubitError>? errors,
    Set<CubitEvent>? events,
  })  : actions = UnmodifiableSetView(actions ?? <CubitAction>{}),
        errors = UnmodifiableSetView(errors ?? <CubitError>{}),
        events = UnmodifiableSetView(events ?? <CubitEvent>{});

  /// Method for creating a copy of this [BaseState].
  BaseState copyWith();

  /// Adds the passed action to the current actions and returns the
  /// new set.
  Set<CubitAction> addAction(CubitAction action) => actions.union({action});

  /// Adds the passed actions to the current actions and returns the
  /// new set.
  Set<CubitAction> addActions(Set<CubitAction> actions) =>
      actions.union(actions);

  /// Removes the passed action from the current actions and returns the
  /// new set.
  Set<CubitAction> removeAction(CubitAction action) =>
      actions.difference({action});

  /// Removes the passed actions from the current actions and returns the
  /// new set.
  Set<CubitAction> removeActions(Set<CubitAction> actions) =>
      actions.difference(actions);

  /// Builds the corresponding [CubitError] with the passed action and
  /// exception, adds it to the current errors and returns the new set.
  Set<CubitError> addErrorFromException({
    required CubitAction action,
    required Exception exception,
  }) {
    if (exception is NetException) {
      if (exception.code == null) {
        return errors.union({
          CubitConnectivityError<CubitAction>(
            action: action,
          )
        });
      }

      return errors.union({
        CubitAPIError<CubitAction>(
          action: action,
          code: exception.code?.toCubitErrorCode(),
          message: exception.message,
        )
      });
    }

    /// Corner case. The error concentrator should handle this.
    throw exception;
  }

  /// Builds a [CubitValidationError] with the passed validation error code,
  /// adds  it to the current errors and returns the new set.
  Set<CubitError> addValidationError({
    required ValidationErrorCode validationErrorCode,
  }) =>
      errors.union({
        CubitValidationError<ValidationErrorCode>(
          validationErrorCode: validationErrorCode,
        ),
      });

  /// Adds a custom error to the errors and returns the new set.
  Set<CubitError> addCustomCubitError({
    CubitAction? action,
    CubitErrorCode? code,
    String? message,
  }) =>
      errors.union({
        CubitCustomError<CubitAction>(
          action: action,
          code: code,
          message: message,
        )
      });

  /// Removes any error related to the passed action and returns the new set.
  Set<CubitError> removeErrorForAction(CubitAction action) => errors
      .where((error) =>
          (error is CubitConnectivityError<CubitAction> ||
              error is CubitConnectivityError<CubitAction>) &&
          error.action != action)
      .toSet();

  /// Removes all the validation errors and returns the new set of errors.
  Set<CubitError> clearValidationErrors() => errors.difference(
        errors.whereType<CubitValidationError<ValidationErrorCode>>().toSet(),
      );

  /// Adds the passed event to the current events and returns the
  /// new set.
  Set<CubitEvent> addEvent(CubitEvent event) => events.union({event});

  /// Adds the passed events to the current events and returns the
  /// new set.
  Set<CubitEvent> addEvents(Set<CubitEvent> events) => events.union(events);

  /// Removes the passed event from the current events and returns the
  /// new set.
  Set<CubitEvent> removeEvent(CubitEvent event) => events.difference({event});

  /// Removes the passed events from the current events and returns the
  /// new set.
  Set<CubitEvent> removeEvents(Set<CubitEvent> events) =>
      events.difference(events);
}

/// Extension for mapping status codes returned by the API
/// into [CubitErrorCode]s
extension CubitErrorCodeMappingExtension on String? {
  /// Maps a status code into a [CubitErrorCode].
  CubitErrorCode? toCubitErrorCode() {
    switch (this) {
      case 'insufficient_balance':
        return CubitErrorCode.insuficientBalance;

      case 'incorrect_value':
        return CubitErrorCode.incorrectOTPCode;

      default:
        return null;
    }
  }
}
