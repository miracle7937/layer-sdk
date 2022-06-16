import 'package:equatable/equatable.dart';
import '../../../../../domain_layer/models.dart';
import '../../../../data_layer/data_layer.dart';

/// The available error status
enum AuthenticationErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Username and password are required
  emptyFields,

  /// The user has been suspended error
  suspendedUser,

  /// Invalid user error
  invalidUser,

  /// Wrong credentials error
  wrongCredentials,

  /// The user credentials have expired error
  expired,

  /// The user has to change his password
  changePassword,

  /// If failed to reset the password
  resetPasswordFailed,

  /// Network error
  network,

  /// Error changing password
  changePasswordFailed,

  /// Error recovering password
  recoverPasswordFailed,

  /// This console user calendar is currently closed.
  calendarClosed,
}

/// The available authentication actions
enum AuthenticationAction {
  /// No actions
  none,

  /// The user requested to reset his password
  requestedResetPassword,

  /// The user did reset his password
  didResetPassword,

  /// The password was changed.
  passwordChanged,

  /// OTP verification.
  otpVerification,
}

/// All the data needed to handle authentication
class AuthenticationState extends Equatable {
  /// The logged-in user. If null, no user is logged in.
  final User? user;

  /// The current error status.
  final AuthenticationErrorStatus errorStatus;

  /// The error message.
  final String? errorMessage;

  /// True if the cubit is processing something.
  final bool busy;

  /// If a user is logged in.
  ///
  /// This is calculated automatically on the object creation.
  final bool isLoggedIn;

  /// The authentication action required.
  final AuthenticationAction authenticationAction;

  /// The [VerifyPinResponse] containing the pin verification result
  final VerifyPinResponse verifyPinResponse;

  /// If the user was locked out of the app
  /// and must authenticate again
  // TODO: consider unifying `isLocked` and `isPinVerified`
  final bool isLocked;

  /// Whether or not the 2FA was validated.
  final bool validated;

  /// Creates a new authentication state
  AuthenticationState({
    this.user,
    this.errorStatus = AuthenticationErrorStatus.none,
    String? errorMessage,
    this.busy = false,
    this.authenticationAction = AuthenticationAction.none,
    this.verifyPinResponse = const VerifyPinResponse(),
    this.isLocked = false,
    this.validated = false,
  })  : isLoggedIn = user != null && validated,
        errorMessage =
            errorStatus == AuthenticationErrorStatus.none ? null : errorMessage;

  @override
  List<Object?> get props => [
        user,
        errorStatus,
        errorMessage,
        busy,
        isLoggedIn,
        authenticationAction,
        verifyPinResponse,
        isLocked,
        validated,
      ];

  /// Creates a new state based on this one.
  AuthenticationState copyWith({
    User? user,
    AuthenticationErrorStatus? errorStatus,
    String? errorMessage,
    bool? busy,
    AuthenticationAction? authenticationAction,
    VerifyPinResponse? verifyPinResponse,
    bool? isLocked,
    bool? validated,
  }) =>
      AuthenticationState(
        user: user ?? this.user,
        errorStatus: errorStatus ?? this.errorStatus,
        errorMessage: errorStatus == AuthenticationErrorStatus.none
            ? null
            : (errorMessage ?? this.errorMessage),
        busy: busy ?? this.busy,
        authenticationAction: authenticationAction ?? this.authenticationAction,
        verifyPinResponse: verifyPinResponse ?? this.verifyPinResponse,
        isLocked: isLocked ?? this.isLocked,
        validated: validated ?? this.validated,
      );
}
