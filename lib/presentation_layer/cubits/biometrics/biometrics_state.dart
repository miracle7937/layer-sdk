import 'package:equatable/equatable.dart';

/// All the available errors.
enum BiometricsError {
  /// None.
  none,

  /// Generic error.
  generic,

  /// Network error,
  network,

  /// Biometrics changed and all users should be wiped from the device.
  biometricsChanged,
}

/// The state for the [BiometricsCubit].
class BiometricsState extends Equatable {
  /// Whether if the cubit is loading something or not.
  final bool busy;

  /// Whether if the biometrics can be used or not.
  final bool? canUseBiometrics;

  /// Whether if the user authenticated successfully or not.
  final bool? authenticated;

  /// The current error.
  /// Default is [BiometricsError.none].
  final BiometricsError error;

  /// Creates a new [BiometricsState].
  BiometricsState({
    this.busy = false,
    this.canUseBiometrics,
    this.authenticated,
    this.error = BiometricsError.none,
  });

  /// Creates a copy of this state.
  BiometricsState copyWith({
    bool? busy,
    bool? canUseBiometrics,
    bool? authenticated,
    BiometricsError? error,
  }) =>
      BiometricsState(
        busy: busy ?? this.busy,
        canUseBiometrics: canUseBiometrics ?? this.canUseBiometrics,
        authenticated: authenticated ?? this.authenticated,
        error: (busy ?? false) ? BiometricsError.none : error ?? this.error,
      );

  @override
  List<Object?> get props => [
        busy,
        canUseBiometrics,
        authenticated,
        error,
      ];
}
