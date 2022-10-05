import 'package:equatable/equatable.dart';

/// Possible OCRA authentication errors.
enum OcraAuthenticationError {
  /// A generic failure.
  generic,

  /// Verification of the server response to the client challenge failed.
  ///
  /// This means that either the server is using a different secret key,
  /// a different OCRA suite, passes different parameters to the algorithm
  /// or the API was compromised.
  serverAuthenticationFailed,

  /// The device has been deactivated.
  deviceInactive,

  /// The entered PIN is not correct.
  wrongPin,

  /// No error was raised so far.
  none,
}

/// The state of the `OcraAuthenticationCubit`
class OcraAuthenticationState extends Equatable {
  /// True if the cubit is generating a token.
  final bool busy;

  /// The generated access token.
  final String? token;

  /// The error raised during token generation.
  final OcraAuthenticationError error;

  /// The remaining attempts before the device will be deactivated.
  final int? remainingAttempts;

  /// Generated OCRA challenge.
  final String? ocraChallenge;

  /// Creates new [OcraAuthenticationState].
  OcraAuthenticationState({
    this.busy = false,
    this.token,
    this.error = OcraAuthenticationError.none,
    this.remainingAttempts,
    this.ocraChallenge,
  });

  /// Creates a new state based on this one.
  OcraAuthenticationState copyWith({
    bool? busy,
    String? token,
    OcraAuthenticationError? error,
    int? remainingAttempts,
    String? ocraChallenge,
  }) {
    return OcraAuthenticationState(
      busy: busy ?? this.busy,
      token: token ?? this.token,
      error: error ?? this.error,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      ocraChallenge: ocraChallenge ?? this.ocraChallenge,
    );
  }

  @override
  List<Object?> get props => [
        busy,
        token,
        error,
        remainingAttempts,
        ocraChallenge,
      ];
}
