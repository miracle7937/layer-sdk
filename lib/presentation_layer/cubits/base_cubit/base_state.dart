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
  /// Insufficient balance.
  insufficientBalance('insufficient_balance'),

  /// The customer has exceeded the daily limit for the number of international
  /// transfers.
  customerDailyInternationalTransferLimitExceeded(
    'customer_lim_int_daily_exceeded',
  ),

  /// Incorrect OTP code.
  incorrectOTPCode('incorrect_value'),

  /// Invalid second factor.
  invalidSecondFactor('invalid_second_factor'),

  /// The transfer failed.
  transferFailed('transfer_failed'),

  /// The payment failed.
  paymentFailed('payment_failed'),

  /// The transaction not found.
  transactionNotFound('transaction_not_found'),

  /// Bad request. (400 status code)
  badRequest('BAD_REQUEST'),

  /// Unknown error code.
  ///
  /// If you get this, it means that you are getting an error code from the
  /// API that you are not handling here.
  unknown('unknown');

  /// The string value for the [CubitErrorCode].
  final String value;

  /// Creates a new [CubitErrorCode] with the passed value.
  const CubitErrorCode(this.value);

  /// Creates a new [CubitErrorCode] from a passed string.
  factory CubitErrorCode.fromString(String? code) => values.singleWhere(
        (value) => value.value == code,
        orElse: () => unknown,
      );
}

/// The base abstract error class.
///
/// All cubit errors should extend this.
abstract class CubitError extends Equatable {}

/// Cubit error representing a connectivity error.
class CubitConnectivityError<CubitAction> extends CubitError {
  /// The action that the cubit was performing when the error occurred .
  final CubitAction action;

  /// Creates a new [CubitConnectivityError].
  CubitConnectivityError({
    required this.action,
  }) : super();

  @override
  List<Object?> get props => [
        action,
      ];
}

/// Cubit error representing an API error.
class CubitAPIError<CubitAction> extends CubitError {
  /// The action that the cubit was performing when the error occurred .
  final CubitAction action;

  /// The optional error code.
  final CubitErrorCode? code;

  /// The optional error message.
  final String? message;

  /// Creates a new [CubitAPIError].
  CubitAPIError({
    required this.action,
    this.code,
    this.message,
  }) : super();

  @override
  List<Object?> get props => [
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
  }) : super();

  @override
  List<Object?> get props => [
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
  }) : super();

  @override
  List<Object?> get props => [
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

  /// Removed the passed errors from all the errors
  Set<CubitError> removeErrors(Set<CubitError> errors) =>
      errors.difference(errors);

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
    if (exception is ConnectivityException) {
      return errors.union({
        CubitConnectivityError<CubitAction>(
          action: action,
        )
      });
    } else if (exception is NetException) {
      return errors.union({
        CubitAPIError<CubitAction>(
          action: action,
          code: CubitErrorCode.fromString(exception.code),
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

  /// Adds the passed [CubitValidationError] set to the current errors and
  ///  returns the new set.
  Set<CubitError> addValidationErrors({
    required Set<CubitValidationError<ValidationErrorCode>> validationErrors,
  }) =>
      errors.union(validationErrors);

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
  Set<CubitError> removeErrorForAction(CubitAction action) =>
      errors.where((error) {
        final isValidationError = error is CubitValidationError;
        final action = error is CubitConnectivityError<CubitAction>
            ? error.action
            : error is CubitAPIError<CubitAction>
                ? error.action
                : error is CubitCustomError<CubitAction>
                    ? error.action
                    : null;

        return isValidationError || action != action;
      }).toSet();

  /// Removes the passed validation error related to the passed validation
  /// error code.
  Set<CubitError> removeValidationError(
          ValidationErrorCode validationErrorCode) =>
      errors.difference(
        errors
            .whereType<CubitValidationError<ValidationErrorCode>>()
            .where((error) => error.validationErrorCode == validationErrorCode)
            .toSet(),
      );

  /// Removes all the validation errors and returns the new set of errors.
  Set<CubitError> clearValidationErrors() => errors.difference(
        errors.whereType<CubitValidationError<ValidationErrorCode>>().toSet(),
      );

  /// Returns whether if the passed action contains errors or not.
  bool actionHasErrors(CubitAction action) =>
      errors
          .whereType<CubitConnectivityError<CubitAction>>()
          .where((error) => error.action == action)
          .isNotEmpty ||
      errors
          .whereType<CubitAPIError<CubitAction>>()
          .where((error) => error.action == action)
          .isNotEmpty ||
      errors
          .whereType<CubitCustomError<CubitAction>>()
          .where((error) => error.action == action)
          .isNotEmpty;

  /// Adds the passed event to the current events and returns the
  /// new set.
  Set<CubitEvent> addEvent(CubitEvent event) => events.union({event});

  /// Removes the passed event from the current events and returns the
  /// new set.
  Set<CubitEvent> removeEvent(CubitEvent event) => events.difference({event});

  /// Removes the passed events from the current events and returns the
  /// new set.
  Set<CubitEvent> removeEvents(Set<CubitEvent> events) =>
      events.difference(events);
}
