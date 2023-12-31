import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../../data_layer/network.dart';
import '../../../../../domain_layer/models.dart';
import '../../../data_layer/providers.dart';
import '../../../data_layer/repositories.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';
import '../../utils.dart';

/// Maintains the states of authentication on the app.
///
/// The use cases are protected instead of private to allow access from classes
/// extending the cubit. They are not intended to be accessed from any UI code.
class AuthenticationCubit extends Cubit<AuthenticationState> {
  /// The use case containing login logic.
  @protected
  final LoginUseCase loginUseCase;

  /// The use case containing logout logic.
  @protected
  final LogoutUseCase logoutUseCase;

  /// The use case containing password recovery logic.
  @protected
  final RecoverPasswordUseCase recoverPasswordUseCase;

  /// The use case containing password reset logic.
  @protected
  final ResetPasswordUseCase resetPasswordUseCase;

  /// The use case containing password change logic.
  @protected
  final ChangePasswordUseCase changePasswordUseCase;

  /// The use case containing access pin verification logic.
  @protected
  final VerifyAccessPinUseCase verifyAccessPinUseCase;

  /// The use case containing user token update logic.
  @protected
  final UpdateUserTokenUseCase updateUserTokenUseCase;

  /// The use case containing current customer loading logic.
  @protected
  final LoadCurrentCustomerUseCase customerUseCase;

  /// The use case containing device model loading logic.
  @protected
  final GetDeviceModelUseCase getDeviceModelUseCase;

  /// The use case containing user details loading logic.
  @protected
  final LoadUserDetailsFromTokenUseCase loadUserDetailsFromTokenUseCase;

  final bool _shouldGetCustomerObject;

  /// Flag param to handle if we have to show the auto lock screen or not
  ///
  /// Defaults to `true`
  bool _shouldAllowAutoLock = true;

  /// Creates a new cubit with an empty [AuthenticationState] and calls
  /// load settings
  AuthenticationCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.recoverPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.changePasswordUseCase,
    required this.verifyAccessPinUseCase,
    required this.updateUserTokenUseCase,
    required this.customerUseCase,
    required this.getDeviceModelUseCase,
    bool shouldGetCustomerObject = false,
    required this.loadUserDetailsFromTokenUseCase,
  })  : _shouldGetCustomerObject = shouldGetCustomerObject,
        super(AuthenticationState());

  /// Method that disables the auto lock before running the passed future and
  /// enables it again when the future finishes.
  ///
  /// Use this when you need to run 3rd party code which will put the app in
  /// background before resuming the app and completing the flow.
  ///
  /// Fore example: Running Jumio, Picking a file, etc.
  Future<void> disableAutoLock({
    required Future Function() future,
  }) async {
    _shouldAllowAutoLock = false;
    await future();
    _shouldAllowAutoLock = true;
  }

  /// Sets the provided user as the current logged user and emits updated state.
  ///
  /// Configures the [NetClient] token with the user token.
  void setLoggedUser(User user) {
    updateUserTokenUseCase(token: user.token);
    if (_shouldGetCustomerObject) loadCustomerObject();
    emit(state.copyWith(user: user));
  }

  /// Gets the user details using the registration response token.
  Future<void> getUserDetails(String token) async {
    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final user = await loadUserDetailsFromTokenUseCase(
        token: token,
      );

      emit(
        state.copyWith(
          busy: false,
          user: user,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
        ),
      );
    }
  }

  /// Emits a busy state, then logs the user out on the repository and removes
  /// him from storage. Finally, logs the user out on the cubit by emitting an
  /// empty [AuthenticationState], but preserving the settings.
  Future<void> logout({
    bool deactivateDevice = true,
    int? deviceId,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          errorStatus: AuthenticationErrorStatus.none,
        ),
      );

      /// TODO: we should get the current device id instead of this being
      /// passed from the method or retrieved from the user in the state.
      await logoutUseCase(
        deviceId: deactivateDevice ? (state.user?.deviceId ?? deviceId) : null,
      );

      emit(
        AuthenticationState(),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
      final customerInfo = await customerUseCase();

      emit(
        state.copyWith(
          busy: false,
          customer: customerInfo,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : null,
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

      final deviceName = await RequestHeadersHelper.getDeviceName();
      final deviceModel = await RequestHeadersHelper.getDeviceModel();

      final user = await loginUseCase(
        username: username,
        password: password,
        notificationToken: notificationToken,
        deviceName: deviceName,
        deviceModel: deviceModel,
      );

      var errorStatus =
          user == null ? AuthenticationErrorStatus.wrongCredentials : null;

      if (errorStatus == null) {
        errorStatus = user?.status?.toAuthenticationError();
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
    } on Exception catch (e, st) {
      logException(e, st);
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
      final returnedStatus = await recoverPasswordUseCase(
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
    } on Exception catch (e, st) {
      logException(e, st);
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
      final didResetPassword = await resetPasswordUseCase(
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
    } on Exception catch (e, st) {
      logException(e, st);
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
      final response = await changePasswordUseCase(
        user: user,
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
    } on Exception catch (e, st) {
      logException(e, st);
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
  // TODO: consider renaming `verifyAccessPin` to `updateSessionInfo` and
  // removing the `pin` parameter.
  Future<void> verifyAccessPin(
    String pin, {
    DeviceSession? deviceInfo,
    String? notificationToken,
    String? userToken,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: AuthenticationErrorStatus.none,
      ),
    );

    try {
      final verifyPinResponse = await verifyAccessPinUseCase(
        pin: pin,
        userToken: 'Bearer $userToken',
        deviceInfo: deviceInfo ?? DeviceSession(),
        notificationToken: notificationToken,
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
    } on Exception catch (e, st) {
      logException(e, st);
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
  void setPinNeedsVerification({bool verified = false}) {
    /// Some packages like [Jumio] might put the app on the background mode when
    /// processing the task.
    ///
    /// In that case we need to disable the auto lock behaviour until the
    /// [Jumio] process is finished
    if (_shouldAllowAutoLock) {
      emit(
        state.copyWith(
          verifyPinResponse: VerifyPinResponse(
            isVerified: verified,
          ),
        ),
      );
    }
  }

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
    updateUserTokenUseCase(token: user.token);
    if (_shouldGetCustomerObject) loadCustomerObject();

    emit(
      state.copyWith(
        isLocked: false,
        user: user,
      ),
    );
  }

  /// Get Device model
  Future<String> getModelName() {
    return getDeviceModelUseCase();
  }

  /// Sets the second factor status.
  /// When the `validated` parameter is `false`, the [NetClient] token will be
  /// cleared out. This makes the networking layer use the default token.
  ///
  /// This method should be used together with [SecondFactorCubit].
  void setSecondFactorStatus({
    bool validated = false,
  }) {
    if (!validated) updateUserTokenUseCase(token: null);

    emit(
      state.copyWith(
        validated: validated,
      ),
    );
  }
}

/// Extension that provides mappings for [UserStatus]
extension UserStatusMapping on UserStatus {
  /// Maps into a [AuthenticationErrorStatus].
  AuthenticationErrorStatus? toAuthenticationError() {
    switch (this) {
      case UserStatus.changePassword:
        return AuthenticationErrorStatus.changePassword;

      case UserStatus.suspended:
        return AuthenticationErrorStatus.suspendedUser;

      case UserStatus.expired:
        return AuthenticationErrorStatus.expired;

      case UserStatus.calendarClosed:
        return AuthenticationErrorStatus.calendarClosed;

      default:
        return null;
    }
  }
}
