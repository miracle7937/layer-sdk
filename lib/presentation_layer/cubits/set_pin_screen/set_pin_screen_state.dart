import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status.
enum SetPinScreenError {
  /// No error
  none,

  /// Network error
  network,

  /// Generic error
  generic,
}

/// The state for the [SetPinScreenCubit].
class SetPinScreenState extends Equatable {
  /// Whether if the cubit is loading something or not.
  final bool busy;

  /// The user object returned on the set pin result.
  final User? user;

  /// The current error status.
  final SetPinScreenError error;

  /// The current error message.
  final String? errorMessage;

  /// Creates a new [SetPinScreenState].
  const SetPinScreenState({
    this.busy = false,
    this.user,
    this.error = SetPinScreenError.none,
    this.errorMessage,
  });

  /// Creates a copy of this state with the passed values.
  SetPinScreenState copyWith({
    bool? busy,
    User? user,
    SetPinScreenError? error,
    String? errorMessage,
  }) =>
      SetPinScreenState(
        busy: busy ?? this.busy,
        user: user ?? this.user,
        error: busy ?? false ? SetPinScreenError.none : error ?? this.error,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        busy,
        user,
        error,
        errorMessage,
      ];
}
