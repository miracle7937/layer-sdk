import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';

/// Enum for all possible errors for the [BranchActivationCubit].
enum BranchActivationError {
  /// No errors.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// Enum for all the possible actions for the [BranchActivationCubit].
enum BranchActivationAction {
  /// No action.
  none,

  /// Activation code.
  activationCode,

  /// Second factor check.
  otpCheck,

  /// OTP being resent.
  resendOTP,

  /// User retrieval.
  userRetrieval,

  /// Set access pin,
  setAccessPin,
}

/// The state for the branch activation cubit.
class BranchActivationState extends Equatable {
  /// The activation code to be provided to the branch for introducing it
  /// on the console.
  final String activationCode;

  /// True if the cubit is processing something.
  final bool busy;

  /// The action that is being processed.
  final BranchActivationAction action;

  /// Error message for the last occurred error.
  final BranchActivationError error;

  /// The error message.
  final String? errorMessage;

  /// The registration response obtained when the branch has submitted the
  /// activation code successfully.
  final BranchActivationResponse? activationResponse;

  /// The user object from the get user details response or from the
  /// set pin access response.
  final User? user;

  /// Creates a new [BranchActivationState].
  BranchActivationState({
    required this.activationCode,
    this.busy = false,
    this.action = BranchActivationAction.none,
    this.error = BranchActivationError.none,
    this.errorMessage,
    this.activationResponse,
    this.user,
  });

  /// Creates a copy of this state.
  BranchActivationState copyWith({
    String? activationCode,
    bool? busy,
    BranchActivationAction? action,
    BranchActivationError? error,
    String? errorMessage,
    BranchActivationResponse? activationResponse,
    User? user,
  }) =>
      BranchActivationState(
        activationCode: activationCode ?? this.activationCode,
        busy: busy ?? this.busy,
        action: action ?? this.action,
        error: error ?? this.error,
        errorMessage: error == BranchActivationError.none
            ? null
            : (errorMessage ?? this.errorMessage),
        activationResponse: activationResponse ?? this.activationResponse,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [
        activationCode,
        busy,
        action,
        error,
        errorMessage,
        activationResponse,
        user,
      ];
}
