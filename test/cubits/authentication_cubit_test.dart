import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

late MockAuthenticationRepository _repository;

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    _repository = MockAuthenticationRepository();
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'starts on empty state',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    verify: (c) => expect(c.state, AuthenticationState()),
  ); // starts on empty state

  group('Login/Logout flows', _loginFlowTests);
  group('Access PIN', _accessPinTests);
  group('Password change', _passwordChange);
  group('Recover password', _recoverPassword);
  group('Reset password', _resetPassword);
  group('Lock/Unlock mechanism', _unlock);
}

void _loginFlowTests() {
  final usernameActive = 'user1';
  final passwordActive = 'm1294jag4j';
  final usernameSuspended = 'anotherUser';
  final passwordSuspended = 'eismc7hs5';
  final usernameExpired = 'expiUser';
  final passwordExpired = 'mvh72a54@';
  final usernameException = 'exception_user';
  final passwordException = 'not sure why the other passwords seems so real';
  final usernameNetException = 'net_exception_user';
  final passwordNetException = 'ayylmao123';
  final logoutSuccessId = 1;
  final logoutExceptionId = 2;
  final logoutNetExceptionId = 3;

  final _activeUser = User(
    id: '1',
    username: 'User 1',
    status: UserStatus.active,
    token: 'Token',
    deviceId: logoutSuccessId,
  );
  final _suspendedUser = User(
    id: '2',
    username: 'User 2',
    status: UserStatus.suspended,
  );
  final _expiredUser = User(
    id: '3',
    username: 'User 3',
    status: UserStatus.expired,
  );
  final _exceptionUser = User(
    id: '4',
    username: 'User 4',
    status: UserStatus.active,
    deviceId: logoutExceptionId,
  );
  final _netExceptionUser = User(
    id: '5',
    username: 'User 5',
    status: UserStatus.active,
    deviceId: logoutNetExceptionId,
  );

  setUp(() {
    when(
      () => _repository.login(usernameActive, passwordActive, ''),
    ).thenAnswer((_) async => _activeUser);

    when(
      () => _repository.login(usernameSuspended, passwordSuspended, ''),
    ).thenAnswer((_) async => _suspendedUser);

    when(
      () => _repository.login(usernameExpired, passwordExpired, ''),
    ).thenAnswer((_) async => _expiredUser);

    when(
      () => _repository.login(usernameActive, passwordExpired, ''),
    ).thenAnswer((_) async => null);

    when(
      () => _repository.logout(
        deviceId: logoutSuccessId,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _repository.login(
        usernameException,
        passwordException,
        '',
      ),
    ).thenAnswer((_) async => throw Exception());

    when(
      () => _repository.login(
        usernameNetException,
        passwordNetException,
        '',
      ),
    ).thenAnswer((_) async => throw NetException());

    when(
      () => _repository.logout(deviceId: logoutExceptionId),
    ).thenAnswer((_) async => throw Exception());

    when(
      () => _repository.logout(deviceId: logoutNetExceptionId),
    ).thenAnswer((_) async => throw NetException());
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set user',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.setLoggedUser(_activeUser),
    expect: () => [
      AuthenticationState(user: _activeUser),
    ],
    verify: (c) {
      verify(() => _repository.token = 'Token').called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should logout',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: () => AuthenticationState(
      user: _activeUser,
    ),
    act: (c) => c.logout(),
    expect: () => [
      AuthenticationState(
        busy: true,
        user: _activeUser,
      ),
      AuthenticationState(),
    ],
    verify: (c) {
      verify(() => _repository.logout(deviceId: logoutSuccessId)).called(1);
      verifyNever(
          () => _repository.login(usernameSuspended, passwordSuspended, ''));
    },
  ); // logout on empty state should return an empty state

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should log-in',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: AuthenticationState.new,
    act: (c) => c.login(
      username: usernameActive,
      password: passwordActive,
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        user: _activeUser,
        validated: true,
      ),
    ],
    verify: (c) {
      verify(() => _repository.login(usernameActive, passwordActive, ''))
          .called(1);
    },
  ); // should login

  _emptyFieldsTests();

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit wrong credentials error',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: usernameActive,
      password: passwordExpired,
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.wrongCredentials,
      ),
    ],
    verify: (c) {
      verify(() => _repository.login(usernameActive, passwordExpired, ''))
          .called(1);
    },
  ); // should emit wrong credentials error

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit suspended error',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: usernameSuspended,
      password: passwordSuspended,
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.suspendedUser,
      ),
    ],
    verify: (c) {
      verify(() => _repository.login(usernameSuspended, passwordSuspended, ''))
          .called(1);
    },
  ); // should emit suspended error

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit expired error',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: usernameExpired,
      password: passwordExpired,
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.expired,
      ),
    ],
    verify: (c) {
      verify(() => _repository.login(usernameExpired, passwordExpired, ''))
          .called(1);
    },
  ); // should emit expired error

  blocTest<AuthenticationCubit, AuthenticationState>(
    'login should handle general exceptions gracefully',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: usernameException,
      password: passwordException,
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.login(usernameException, passwordException, ''),
      ).called(1);
    },
    errors: () => [
      isA<Exception>(),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'login should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: usernameNetException,
      password: passwordNetException,
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.network,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.login(usernameNetException, passwordNetException, ''),
      ).called(1);
    },
    errors: () => [
      isA<NetException>(),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'logout should handle general exceptions gracefully',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: () => AuthenticationState(
      user: _exceptionUser,
    ),
    act: (c) => c.logout(),
    expect: () => [
      AuthenticationState(
        busy: true,
        user: _exceptionUser,
      ),
      AuthenticationState(
        busy: false,
        errorStatus: AuthenticationErrorStatus.generic,
        user: _exceptionUser,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.logout(deviceId: logoutExceptionId),
      ).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'logout should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: () => AuthenticationState(
      user: _netExceptionUser,
    ),
    act: (c) => c.logout(),
    expect: () => [
      AuthenticationState(
        busy: true,
        user: _netExceptionUser,
      ),
      AuthenticationState(
        busy: false,
        errorStatus: AuthenticationErrorStatus.network,
        user: _netExceptionUser,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.logout(deviceId: logoutNetExceptionId),
      ).called(1);
    },
  );
}

void _accessPinTests() {
  final correctPin = 'correctPin';
  final incorrectPin = 'incorrectPin';
  final exceptionPin = 'exceptionPin';
  final netExceptionPin = 'netExceptionPin';
  final user = User(id: 'user');

  setUp(() {
    when(
      () => _repository.verifyAccessPin(correctPin),
    ).thenAnswer(
      (_) async => VerifyPinResponse(
        isVerified: true,
      ),
    );

    when(
      () => _repository.verifyAccessPin(incorrectPin),
    ).thenAnswer(
      (_) async => VerifyPinResponse(
        isVerified: false,
      ),
    );

    when(
      () => _repository.verifyAccessPin(exceptionPin),
    ).thenAnswer(
      (_) async => throw Exception(),
    );

    when(
      () => _repository.verifyAccessPin(netExceptionPin),
    ).thenAnswer(
      (_) async => throw NetException(),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should verify access PIN',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.verifyAccessPin(correctPin),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        verifyPinResponse: VerifyPinResponse(
          isVerified: true,
        ),
      ),
    ],
    verify: (c) {
      verify(() => _repository.verifyAccessPin(correctPin)).called(1);
    },
  );
  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set wrong credentials error',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.verifyAccessPin(incorrectPin),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.wrongCredentials,
      ),
    ],
    verify: (c) {
      verify(() => _repository.verifyAccessPin(incorrectPin)).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set PIN needs verification',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: () => AuthenticationState(
      verifyPinResponse: VerifyPinResponse(
        isVerified: true,
      ),
    ),
    act: (c) => c.setPinNeedsVerification(),
    expect: () => [
      AuthenticationState(
        verifyPinResponse: VerifyPinResponse(
          isVerified: false,
        ),
      ),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set access PIN',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: () => AuthenticationState(user: user),
    act: (c) => c.setAccessPin(correctPin),
    expect: () => [
      AuthenticationState(user: user.copyWith(accessPin: correctPin)),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Should not lock a user that is not logged in',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: AuthenticationState.new,
    act: (c) => c.lock(),
    expect: () => [],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Should lock the user out',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    seed: () => AuthenticationState(
      user: user,
      validated: true,
    ),
    act: (c) => c.lock(),
    expect: () => [
      AuthenticationState(
        user: user,
        isLocked: true,
        validated: true,
      ),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'verify access pin should handle generic exceptions gracefully',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.verifyAccessPin(exceptionPin),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        errorStatus: AuthenticationErrorStatus.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(() => _repository.verifyAccessPin(exceptionPin)).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'verify access pin should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.verifyAccessPin(netExceptionPin),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        errorStatus: AuthenticationErrorStatus.network,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(() => _repository.verifyAccessPin(netExceptionPin)).called(1);
    },
  );
}

void _emptyFieldsTests() {
  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if all fields are empty',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: '',
      password: '',
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.emptyFields,
      ),
    ],
    verify: (c) {
      verifyNever(() => _repository.login('', '', ''));
    },
  ); // should emit empty fields error if all fields are empty

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if all fields are null',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: '',
      password: '',
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.emptyFields,
      ),
    ],
    verify: (c) {
      verifyNever(() => _repository.login(any(), any(), any()));
    },
  ); // should emit empty fields error if all fields are null

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if username is empty',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: '',
      password: '123',
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.emptyFields,
      ),
    ],
    verify: (c) {
      verifyNever(() => _repository.login('', '123', ''));
    },
  ); // should emit empty fields error if username is empty

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if password is empty',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.login(
      username: 'superadmin',
      password: '',
      notificationToken: '',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.emptyFields,
      ),
    ],
    verify: (c) {
      verifyNever(() => _repository.login('superadmin', '', ''));
    },
  ); // should emit empty fields error if password is empty
}

void _passwordChange() {
  final _successId = 1;
  final _failureId = 2;
  final _exceptionId = 3;

  final _failMessage = 'Request Failed';

  setUpAll(() {
    when(
      () => _repository.changePassword(
        userId: _successId,
        username: any(named: 'username'),
        oldPassword: any(named: 'oldPassword'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).thenAnswer(
      (_) async => MessageResponse(success: true),
    );

    when(
      () => _repository.changePassword(
        userId: _failureId,
        username: any(named: 'username'),
        oldPassword: any(named: 'oldPassword'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).thenAnswer(
      (_) async => MessageResponse(success: false, message: _failMessage),
    );

    when(
      () => _repository.changePassword(
        userId: _exceptionId,
        username: any(named: 'username'),
        oldPassword: any(named: 'oldPassword'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Emits success action when successfully changing password',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.changePassword(
      user: User(
        id: _successId.toString(),
        username: 'User Success',
      ),
      oldPassword: 'old_password',
      newPassword: 'any_password',
      confirmPassword: 'any_password',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.passwordChanged,
        errorStatus: AuthenticationErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repository.changePassword(
        userId: _successId,
        username: any(named: 'username'),
        oldPassword: any(named: 'oldPassword'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).called(1),
  ); // Emits success action when successfully changing password

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Emits error when failing to change password',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.changePassword(
      user: User(
        id: _failureId.toString(),
        username: 'User Fail',
      ),
      oldPassword: 'old_password',
      newPassword: 'any_password',
      confirmPassword: 'any_password',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorMessage: _failMessage,
        errorStatus: AuthenticationErrorStatus.changePasswordFailed,
      ),
    ],
    verify: (c) => verify(
      () => _repository.changePassword(
        userId: _failureId,
        username: any(named: 'username'),
        oldPassword: any(named: 'oldPassword'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).called(1),
  ); // Emits error when failing to change password

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Emits error when exception happens on password change',
    build: () => AuthenticationCubit(
      repository: _repository,
    ),
    act: (c) => c.changePassword(
      user: User(
        id: _exceptionId.toString(),
        username: 'User Exception',
      ),
      oldPassword: 'old_password',
      newPassword: 'any_password',
      confirmPassword: 'any_password',
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorStatus: AuthenticationErrorStatus.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) => verify(
      () => _repository.changePassword(
        userId: _exceptionId,
        username: any(named: 'username'),
        oldPassword: any(named: 'oldPassword'),
        newPassword: any(named: 'newPassword'),
        confirmPassword: any(named: 'confirmPassword'),
      ),
    ).called(1),
  ); // Emits error when exception happens on password change
}

void _recoverPassword() {
  final _successUsername = 'user1';
  final _invalidUsername = 'user2';
  final _suspendedUsername = 'user3';
  final _notAllowedUsername = 'user4';
  final _exceptionUsername = 'userERROR';

  setUpAll(() {
    when(
      () => _repository.recoverPassword(_successUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.success,
    );

    when(
      () => _repository.recoverPassword(_invalidUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.invalidUser,
    );

    when(
      () => _repository.recoverPassword(_suspendedUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.suspendedUser,
    );

    when(
      () => _repository.recoverPassword(_notAllowedUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.notAllowed,
    );

    when(
      () => _repository.recoverPassword(_exceptionUsername),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles success',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.recoverPassword(username: _successUsername),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.requestedResetPassword,
        errorStatus: AuthenticationErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repository.recoverPassword(_successUsername),
    ).called(1),
  ); // Handles success

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles invalid user',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.recoverPassword(username: _invalidUsername),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorStatus: AuthenticationErrorStatus.invalidUser,
      ),
    ],
    verify: (c) => verify(
      () => _repository.recoverPassword(_invalidUsername),
    ).called(1),
  ); // Handles invalid user

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles suspended user',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.recoverPassword(username: _suspendedUsername),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorStatus: AuthenticationErrorStatus.suspendedUser,
      ),
    ],
    verify: (c) => verify(
      () => _repository.recoverPassword(_suspendedUsername),
    ).called(1),
  ); // Handles suspended user

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles recover not allowed',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.recoverPassword(username: _notAllowedUsername),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorStatus: AuthenticationErrorStatus.recoverPasswordFailed,
      ),
    ],
    verify: (c) => verify(
      () => _repository.recoverPassword(_notAllowedUsername),
    ).called(1),
  ); // Handles recover not allowed

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Emits error when exception thrown',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.recoverPassword(username: _exceptionUsername),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorStatus: AuthenticationErrorStatus.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) => verify(
      () => _repository.recoverPassword(_exceptionUsername),
    ).called(1),
  ); // Emits error when exception thrown
}

void _resetPassword() {
  final successUsername = 'successUsername';
  final successOldPassword = 'successOldPassword';
  final successNewPassword = 'successNewPassword';

  final failureUsername = 'failureUsername';
  final failureOldPassword = 'failureOldPassword';
  final failureNewPassword = 'failureNewPassword';

  final exceptionUsername = 'exceptionUsername';
  final exceptionOldPassword = 'exceptionOldPassword';
  final exceptionNewPassword = 'exceptionNewPassword';

  final netExceptionUsername = 'netExceptionUsername';
  final netExceptionOldPassword = 'netExceptionOldPassword';
  final netExceptionNewPassword = 'netExceptionNewPassword';

  setUp(() {
    when(
      () => _repository.resetPassword(
        successUsername,
        successOldPassword,
        successNewPassword,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.resetPassword(
        failureUsername,
        failureOldPassword,
        failureNewPassword,
      ),
    ).thenAnswer(
      (_) async => false,
    );

    when(
      () => _repository.resetPassword(
        exceptionUsername,
        exceptionOldPassword,
        exceptionNewPassword,
      ),
    ).thenAnswer(
      (_) async => throw Exception(),
    );

    when(
      () => _repository.resetPassword(
        netExceptionUsername,
        netExceptionOldPassword,
        netExceptionNewPassword,
      ),
    ).thenAnswer(
      (_) async => throw NetException(),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should reset password successfully',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.resetPassword(
      username: successUsername,
      newPassword: successNewPassword,
      oldPassword: successOldPassword,
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.didResetPassword,
        errorStatus: AuthenticationErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repository.resetPassword(
        successUsername,
        successOldPassword,
        successNewPassword,
      ),
    ).called(1),
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should handle reset password failure gracefully',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.resetPassword(
      username: failureUsername,
      newPassword: failureNewPassword,
      oldPassword: failureOldPassword,
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        authenticationAction: AuthenticationAction.none,
        errorStatus: AuthenticationErrorStatus.resetPasswordFailed,
      ),
    ],
    verify: (c) => verify(
      () => _repository.resetPassword(
        failureUsername,
        failureOldPassword,
        failureNewPassword,
      ),
    ).called(1),
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should handle general exceptions gracefully',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.resetPassword(
      username: exceptionUsername,
      newPassword: exceptionNewPassword,
      oldPassword: exceptionOldPassword,
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        errorStatus: AuthenticationErrorStatus.generic,
      ),
    ],
    verify: (c) => verify(
      () => _repository.resetPassword(
        exceptionUsername,
        exceptionOldPassword,
        exceptionNewPassword,
      ),
    ).called(1),
    errors: () => [
      isA<Exception>(),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should handle network exceptions gracefully',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.resetPassword(
      username: netExceptionUsername,
      newPassword: netExceptionNewPassword,
      oldPassword: netExceptionOldPassword,
    ),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        busy: false,
        errorStatus: AuthenticationErrorStatus.network,
      ),
    ],
    verify: (c) => verify(
      () => _repository.resetPassword(
        netExceptionUsername,
        netExceptionOldPassword,
        netExceptionNewPassword,
      ),
    ).called(1),
    errors: () => [
      isA<NetException>(),
    ],
  );
}

void _unlock() {
  final user = User(
    id: 'ayylmao',
    token: 'bearer lmao',
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit unlocked state with provided user',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.unlock(user),
    expect: () => [
      AuthenticationState(
        isLocked: false,
        user: user,
      ),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should do nothing when locking without authentication',
    build: () => AuthenticationCubit(repository: _repository),
    act: (c) => c.lock(),
    expect: () => [],
  );
}
