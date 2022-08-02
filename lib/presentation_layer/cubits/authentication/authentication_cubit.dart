import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../../../domain_layer/models.dart';
import '../../../data_layer/providers.dart';
import '../../../data_layer/repositories.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Maintains the states of authentication on the app
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RecoverPasswordUseCase _recoverPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final VerifyAccessPinUseCase _verifyAccessPinUseCase;
  final UpdateUserTokenUseCase _updateUserTokenUseCase;
  final LoadCurrentCustomerUseCase _customerUseCase;
  final bool _shouldGetCustomerObject;

  /// Creates a new cubit with an empty [AuthenticationState] and calls
  /// load settings
  AuthenticationCubit({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RecoverPasswordUseCase recoverPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required VerifyAccessPinUseCase verifyAccessPinUseCase,
    required UpdateUserTokenUseCase updateUserTokenUseCase,
    required LoadCurrentCustomerUseCase customerUseCase,
    bool shouldGetCustomerObject = false,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _recoverPasswordUseCase = recoverPasswordUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _verifyAccessPinUseCase = verifyAccessPinUseCase,
        _updateUserTokenUseCase = updateUserTokenUseCase,
        _shouldGetCustomerObject = shouldGetCustomerObject,
        _customerUseCase = customerUseCase,
        super(AuthenticationState());

  /// Sets the provided user as the current logged user and emits updated state.
  ///
  /// Configures the [NetClient] token with the user token.
  void setLoggedUser(User user) {
    _updateUserTokenUseCase(token: user.token);
    if (_shouldGetCustomerObject) loadCustomerObject();
    emit(state.copyWith(user: user));
  }

  /// Emits a busy state, then logs the user out on the repository and removes
  /// him from storage. Finally, logs the user out on the cubit by emitting an
  /// empty [AuthenticationState], but preserving the settings.
  Future<void> logout({
    bool deactivateDevice = true,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          errorStatus: AuthenticationErrorStatus.none,
        ),
      );

      await _logoutUseCase(
        deviceId: deactivateDevice ? state.user?.deviceId : null,
      );

      emit(
        AuthenticationState(),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Loads the customer's object
  Future<void> loadCustomerObject() async {
    emit(
      state.copyWith(
        busy: true,
        errorMessage: '',
        errorStatus: AuthenticationErrorStatus.none,
      ),
    );

    try {
      final customerInfo = await _customerUseCase();

      emit(
        state.copyWith(
          busy: false,
          customer: customerInfo,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : e.toString(),
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }

  /// Handles the user log-in flow. First emits a busy
  /// and empty [AuthenticationState], and depending on
  /// the [AuthenticationRepository] response, emits the
  /// an [AuthenticationState] with the newly-logged user or with any
  /// errors that have cropped up on the [AuthenticationState.errorStatus].
  Future<void> login({
    required String username,
    required String password,
    String? notificationToken,
  }) async {
    try {
      emit(
        state.copyWith(
          user: null,
          errorStatus: AuthenticationErrorStatus.none,
          authenticationAction: AuthenticationAction.none,
          busy: true,
          isLocked: false,
        ),
      );

      if (username.isEmpty || password.isEmpty) {
        emit(
          state.copyWith(
            errorStatus: AuthenticationErrorStatus.emptyFields,
            busy: false,
          ),
        );

        return;
      }

      final user = await _loginUseCase(
        username: username,
        password: password,
        notificationToken: notificationToken,
      );

      var errorStatus =
          user == null ? AuthenticationErrorStatus.wrongCredentials : null;

      if (errorStatus == null) {
        switch (user!.status) {
          case UserStatus.changePassword:
            errorStatus = AuthenticationErrorStatus.changePassword;
            break;

          case UserStatus.suspended:
            errorStatus = AuthenticationErrorStatus.suspendedUser;
            break;

          case UserStatus.expired:
            errorStatus = AuthenticationErrorStatus.expired;
            break;

          case UserStatus.calendarClosed:
            errorStatus = AuthenticationErrorStatus.calendarClosed;
            break;

          default:
            break;
        }
      }

      final verifyDevice = user?.verifyDevice ?? false;

      emit(
        state.copyWith(
          user: errorStatus != null ? null : user,
          errorStatus: errorStatus ?? AuthenticationErrorStatus.none,
          authenticationAction:
              verifyDevice ? AuthenticationAction.otpVerification : null,
          validated: errorStatus != null ? false : !verifyDevice,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Handles the user recover password flow. First emits
  /// a busy and empty [AuthenticationState], and depending
  /// on the [AuthenticationRepository] response, emits the
  /// [AuthenticationState] depending on the status returned
  /// from the [AuthenticationProvider].
  Future<void> recoverPassword({
    required String username,
  }) async {
    emit(
      state.copyWith(
        user: null,
        errorStatus: AuthenticationErrorStatus.none,
        authenticationAction: AuthenticationAction.none,
        busy: true,
      ),
    );

    try {
      final returnedStatus = await _recoverPasswordUseCase(
        username: username,
      );

      var errorStatus;

      switch (returnedStatus) {
        case ForgotPasswordRequestStatus.invalidUser:
          errorStatus = AuthenticationErrorStatus.invalidUser;
          break;

        case ForgotPasswordRequestStatus.success:
          errorStatus = AuthenticationErrorStatus.none;
          break;

        case ForgotPasswordRequestStatus.suspendedUser:
          errorStatus = AuthenticationErrorStatus.suspendedUser;
          break;

        case ForgotPasswordRequestStatus.notAllowed:
          errorStatus = AuthenticationErrorStatus.recoverPasswordFailed;
          break;

        default:
          break;
      }

      emit(
        state.copyWith(
          errorStatus: errorStatus,
          authenticationAction: errorStatus == AuthenticationErrorStatus.none
              ? AuthenticationAction.requestedResetPassword
              : AuthenticationAction.none,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Handles the user reset password flow. First emits
  /// a busy and empty [AuthenticationState], and depending
  /// on the [AuthenticationRepository] response, emits the
  /// [AuthenticationState] depending on the status returned
  /// from the [AuthenticationProvider].
  Future<void> resetPassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(
      state.copyWith(
        user: null,
        errorStatus: AuthenticationErrorStatus.none,
        authenticationAction: AuthenticationAction.none,
        busy: true,
      ),
    );

    try {
      final didResetPassword = await _resetPasswordUseCase(
        username: username,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      emit(
        state.copyWith(
          errorStatus: didResetPassword
              ? AuthenticationErrorStatus.none
              : AuthenticationErrorStatus.resetPasswordFailed,
          authenticationAction: didResetPassword
              ? AuthenticationAction.didResetPassword
              : AuthenticationAction.none,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Attempts to change the user password
  void changePassword({
    required User user,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: AuthenticationErrorStatus.none,
        authenticationAction: AuthenticationAction.none,
      ),
    );

    try {
      final response = await _changePasswordUseCase(
        userId: int.tryParse(user.id),
        user: user,
        username: user.username,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      emit(
        state.copyWith(
          authenticationAction: response.success
              ? AuthenticationAction.passwordChanged
              : AuthenticationAction.none,
          errorStatus: response.success
              ? AuthenticationErrorStatus.none
              : AuthenticationErrorStatus.changePasswordFailed,
          errorMessage: response.message,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Verifies the provided access pin.
  ///
  /// Emits a busy state while checking and a state with verification result
  /// in the `isPinVerified` field.
  Future<void> verifyAccessPin(String pin) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: AuthenticationErrorStatus.none,
      ),
    );

    try {
      final verifyPinResponse = await _verifyAccessPinUseCase(
        pin: pin,
      );

      emit(
        state.copyWith(
          busy: false,
          verifyPinResponse: verifyPinResponse,
          errorStatus: verifyPinResponse.isVerified
              ? AuthenticationErrorStatus.none
              : AuthenticationErrorStatus.wrongCredentials,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? AuthenticationErrorStatus.network
              : AuthenticationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Emits a state with `isPinVerified` set to the [verified] value
  /// (defaults to false).
  ///
  /// Used to indicate that the user need to verify the pin to continue
  /// using the app.
  void setPinNeedsVerification({bool verified = false}) => emit(
        state.copyWith(
          verifyPinResponse: VerifyPinResponse(
            isVerified: verified,
          ),
        ),
      );

  /// Sets the access pin of the logged user.
  ///
  /// The request to set the PIN on the BE is not implemented yet, this method
  /// only updates the [AuthenticationState] for now and the request
  /// is handled by core-banking.
  Future<void> setAccessPin(String accessPin) async {
    // TODO: implement the request to set access pin on the BE
    // when we refactor that on the Flutter layer
    emit(
      state.copyWith(
        user: state.user?.copyWith(
          accessPin: accessPin,
        ),
      ),
    );
  }

  /// Emits a state with `isLocked` set to true
  ///
  /// Used to indicate that the user needs to use biometrics to
  /// continue using the app
  Future<void> lock() async {
    if (!state.isLoggedIn) return;

    emit(
      state.copyWith(
        isLocked: true,
      ),
    );
  }

  /// Method to be called after the user authenticates
  /// using biometrics successfully
  void unlock(User user) {
    _updateUserTokenUseCase(token: user.token);
    if (_shouldGetCustomerObject) loadCustomerObject();

    emit(
      state.copyWith(
        isLocked: false,
        user: user,
      ),
    );
  }

  /// Sets the second factor status.
  /// When the `validated` parameter is `false`, the [NetClient] token will be
  /// cleared out. This makes the networking layer use the default token.
  ///
  /// This method should be used together with [SecondFactorCubit].
  void setSecondFactorStatus({
    bool validated = false,
  }) {
    if (!validated) _updateUserTokenUseCase(token: null);

    emit(
      state.copyWith(
        validated: validated,
      ),
    );
  }
}
