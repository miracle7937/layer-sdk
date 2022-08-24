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
}

/// The error codes that can occur inside a cubit.
enum CubitErrorCode {
  /// Insuficient balance.
  insuficientBalance,

  /// Invalid IBAN.
  invalidIBAN,

  /// Incorrect OTP code.
  incorrectOTPCode,

  /// The transfer failed.
  transferFailed,
}

/// Model that represents an error that occured inside a cubit.
class CubitError<CubitAction> extends Equatable {
  /// The action that the cubit was performing when the error occurred .
  final CubitAction action;

  /// The error type.
  final CubitErrorType type;

  /// The optional error code.
  final CubitErrorCode? code;

  /// The optinal error message.
  final String? message;

  /// Creates a new [CubitError].
  const CubitError({
    required this.action,
    required this.type,
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [
        action,
        type,
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
abstract class BaseState<CubitAction, CubitEvent> extends Equatable {
  /// The actions that the cubit is performing.
  final UnmodifiableSetView<CubitAction> actions;

  /// The cubit errors.
  final UnmodifiableSetView<CubitError<CubitAction>> errors;

  /// The events that the cubit has emitted for the UI to perform.
  final UnmodifiableSetView<CubitEvent> events;

  /// Creates a new [BaseState].
  BaseState({
    Set<CubitAction>? actions,
    Set<CubitError<CubitAction>>? errors,
    Set<CubitEvent>? events,
  })  : actions = UnmodifiableSetView(actions ?? <CubitAction>{}),
        errors = UnmodifiableSetView(errors ?? <CubitError<CubitAction>>{}),
        events = UnmodifiableSetView(events ?? <CubitEvent>{});

  /// Method for creating a copy of this [BaseState].
  BaseState<CubitAction, CubitEvent> copyWith();

  /// Adds the passed action to the current actions and returns the
  /// new set.
  Set<CubitAction> addBusyAction(CubitAction action) => actions.union({action});

  /// Adds the passed actions to the current actions and returns the
  /// new set.
  Set<CubitAction> addBusyActions(Set<CubitAction> actions) =>
      actions.union(actions);

  /// Removes the passed action from the current actions and returns the
  /// new set.
  Set<CubitAction> removeBusyAction(CubitAction action) =>
      actions.difference({action});

  /// Removes the passed actions from the current actions and returns the
  /// new set.
  Set<CubitAction> removeBusyActions(Set<CubitAction> actions) =>
      actions.difference(actions);

  /// Builds a [CubitError] with the passed action and exception, adds it to
  /// the current errors and returns the new set.
  Set<CubitError<CubitAction>> addCubitError({
    required CubitAction action,
    required Exception exception,
  }) =>
      errors.union({
        CubitError<CubitAction>(
          action: action,
          type: exception is NetException
              ? exception.code == null
                  ? CubitErrorType.connectivity
                  : CubitErrorType.api
              : CubitErrorType.generic,
          code: exception is NetException
              ? exception.code?.toCubitErrorCode()
              : null,
          message: exception is NetException ? exception.message : null,
        )
      });

  /// Adds a custom error to the errors and returns the new set.
  Set<CubitError<CubitAction>> addCustomCubitError({
    required CubitAction action,
    CubitErrorCode? code,
    String? message,
  }) =>
      errors.union({
        CubitError<CubitAction>(
          action: action,
          type: CubitErrorType.custom,
          code: code,
          message: message,
        )
      });

  /// Removes any error related to the passed action and returns the new set.
  Set<CubitError<CubitAction>> removeCubitError(CubitAction action) =>
      errors.where((error) => error.action != action).toSet();

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
