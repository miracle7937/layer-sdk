import '../base_cubit/base_state.dart';

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

/// Represents the actions that can be performed by [OcraAuthenticationCubit]
enum OcraAuthenticationAction {
  /// Getting server challenge
  gettingServerChallenge,
}

/// Represents the error codes that can be returned by [OcraAuthenticationCubit]
enum OcraAuthenticationActionErrorCode {
  /// Network error
  network,

  /// Generic error
  generic
}

/// TODO: Migrate to BaseState and remove old stuff
/// The state of the `OcraAuthenticationCubit`
class OcraAuthenticationState extends BaseState<OcraAuthenticationAction, void,
    OcraAuthenticationActionErrorCode> {
  /// True if the cubit is generating a token.
  final bool busy;

  /// The generated access token.
  final String? token;

  /// The error raised during token generation.
  final OcraAuthenticationError error;

  /// The remaining attempts before the device will be deactivated.
  final int? remainingAttempts;

  /// The client response to be used for 2FA
  final String? clientResponse;

  /// Creates new [OcraAuthenticationState].
  OcraAuthenticationState({
    this.busy = false,
    this.token,
    this.error = OcraAuthenticationError.none,
    this.remainingAttempts,
    this.clientResponse,
    super.actions = const <OcraAuthenticationAction>{},
    super.errors = const <CubitError>{},
  });

  /// Creates a new state based on this one.
  OcraAuthenticationState copyWith({
    bool? busy,
    String? token,
    OcraAuthenticationError? error,
    int? remainingAttempts,
    String? clientResponse,
    Set<OcraAuthenticationAction>? actions,
    Set<CubitError>? errors,
  }) {
    return OcraAuthenticationState(
      busy: busy ?? this.busy,
      token: token ?? this.token,
      error: error ?? this.error,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      clientResponse: clientResponse ?? this.clientResponse,
    );
  }

  @override
  List<Object?> get props => [
        busy,
        token,
        error,
        remainingAttempts,
        clientResponse,
        actions,
        events,
        errors,
      ];
}
