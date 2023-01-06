import 'package:equatable/equatable.dart';

/// A state representing the progress in the corporate registration process.
class CorporateRegistrationState extends Equatable {
  /// True when cubits performs an operation.
  final bool busy;

  /// The state of an error that could be thrown when performing registration.
  final CorporateRegistrationStateError error;

  /// The latest action emited by the cubit.
  final CorporateRegistrationActions action;

  /// Creates [CorporateRegistrationState].
  const CorporateRegistrationState({
    this.busy = false,
    this.error = CorporateRegistrationStateError.none,
    this.action = CorporateRegistrationActions.none,
  });

  /// Returns a new [CorporateRegistrationState] modified by provided values.
  CorporateRegistrationState copyWith({
    bool? busy,
    CorporateRegistrationStateError? error,
    CorporateRegistrationActions? action,
  }) =>
      CorporateRegistrationState(
        busy: busy ?? this.busy,
        error: error ?? this.error,
        action: action ?? this.action,
      );

  @override
  List<Object?> get props => [
        busy,
        error,
        action,
      ];
}

/// Represents the actions that can be done by the cubit.
enum CorporateRegistrationActions {
  /// No action.
  none,

  /// Registration was successfull.
  registrationComplete,
}

/// An enum that defines possible error states
/// for the [CorporateRegistrationState]
enum CorporateRegistrationStateError {
  /// There is no error.
  none,

  /// Customer is already registered.
  customerRegistered,

  /// A generic error happened.
  generic,
}
