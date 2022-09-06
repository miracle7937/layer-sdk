import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/data_layer/providers.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockRecoverPasswordUseCase extends Mock
    implements RecoverPasswordUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockVerifyAccessPinUseCase extends Mock
    implements VerifyAccessPinUseCase {}

class MockUpdateUserTokenUseCase extends Mock
    implements UpdateUserTokenUseCase {}

class MockLoadDeveloperUserDetailsFromTokenUseCase extends Mock
    implements LoadDeveloperUserDetailsFromTokenUseCase {}

final _changePasswordUseCase = MockChangePasswordUseCase();
final _loginUseCase = MockLoginUseCase();
final _logoutUseCase = MockLogoutUseCase();
final _recoverPasswordUseCase = MockRecoverPasswordUseCase();
final _resetPasswordUseCase = MockResetPasswordUseCase();
final _verifyAccessPinUseCase = MockVerifyAccessPinUseCase();
final _updateUserTokenUseCase = MockUpdateUserTokenUseCase();
final _loadDeveloperUserDetailsFromTokenUseCase =
    MockLoadDeveloperUserDetailsFromTokenUseCase();

void main() {
  EquatableConfig.stringify = true;

  blocTest<AuthenticationCubit, AuthenticationState>(
    'starts on empty state',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    verify: (c) => expect(c.state, AuthenticationState()),
  ); // starts on empty state

  group('Login/Logout flows', _loginFlowTests);
  group('Access PIN', _accessPinTests);
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
  final successToken = 'sometoken';
  final successId = 'successId';
  final netExceptionToken = 'netExceptionToken';
  final netExceptionId = 'netExceptionId';
  final exceptionToken = 'exceptionToken';
  final exceptionId = 'exceptionId';

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
      () => _loginUseCase(
          username: usernameActive,
          password: passwordActive,
          notificationToken: ''),
    ).thenAnswer((_) async => _activeUser);

    when(
      () => _loginUseCase(
          username: usernameSuspended,
          password: passwordSuspended,
          notificationToken: ''),
    ).thenAnswer((_) async => _suspendedUser);

    when(
      () => _loginUseCase(
          username: usernameExpired,
          password: passwordExpired,
          notificationToken: ''),
    ).thenAnswer((_) async => _expiredUser);

    when(
      () => _loginUseCase(
          username: usernameActive,
          password: passwordExpired,
          notificationToken: ''),
    ).thenAnswer((_) async => null);

    when(
      () => _logoutUseCase(
        deviceId: logoutSuccessId,
      ),
    ).thenAnswer((_) async => true);

    when(
      () => _loginUseCase(
        username: usernameException,
        password: passwordException,
        notificationToken: '',
      ),
    ).thenAnswer((_) async => throw Exception());

    when(
      () => _loginUseCase(
        username: usernameNetException,
        password: passwordNetException,
        notificationToken: '',
      ),
    ).thenAnswer((_) async => throw NetException());

    when(
      () => _logoutUseCase(deviceId: logoutExceptionId),
    ).thenAnswer((_) async => throw Exception());

    when(
      () => _logoutUseCase(deviceId: logoutNetExceptionId),
    ).thenAnswer((_) async => throw NetException());

    when(
      () => _updateUserTokenUseCase(
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => null);

    when(
      () => _loadDeveloperUserDetailsFromTokenUseCase(
        token: successToken,
        developerId: successId,
      ),
    ).thenAnswer(
      (_) async => _activeUser,
    );

    when(
      () => _loadDeveloperUserDetailsFromTokenUseCase(
        token: successToken,
        developerId: successId,
      ),
    ).thenAnswer(
      (_) async => _activeUser,
    );

    when(
      () => _loadDeveloperUserDetailsFromTokenUseCase(
        token: netExceptionToken,
        developerId: netExceptionId,
      ),
    ).thenThrow(
      NetException(),
    );

    when(
      () => _loadDeveloperUserDetailsFromTokenUseCase(
        token: exceptionToken,
        developerId: exceptionId,
      ),
    ).thenThrow(
      Exception('ayylmao'),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set user',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.setLoggedUser(_activeUser),
    expect: () => [
      AuthenticationState(user: _activeUser),
    ],
    verify: (c) {
      verify(() => _updateUserTokenUseCase(token: 'Token')).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should logout',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _logoutUseCase(deviceId: logoutSuccessId)).called(1);
      verifyNever(() => _loginUseCase(
          username: usernameSuspended,
          password: passwordSuspended,
          notificationToken: ''));
    },
  ); // logout on empty state should return an empty state

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should log-in',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _loginUseCase(
          username: usernameActive,
          password: passwordActive,
          notificationToken: '')).called(1);
    },
  ); // should login

  _emptyFieldsTests();

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit wrong credentials error',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _loginUseCase(
          username: usernameActive,
          password: passwordExpired,
          notificationToken: '')).called(1);
    },
  ); // should emit wrong credentials error
  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit suspended error',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _loginUseCase(
          username: usernameSuspended,
          password: passwordSuspended,
          notificationToken: '')).called(1);
    },
  ); // should emit suspended error

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit expired error',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _loginUseCase(
          username: usernameExpired,
          password: passwordExpired,
          notificationToken: '')).called(1);
    },
  ); // should emit expired error

  blocTest<AuthenticationCubit, AuthenticationState>(
    'login should handle general exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
        () => _loginUseCase(
            username: usernameException,
            password: passwordException,
            notificationToken: ''),
      ).called(1);
    },
    errors: () => [
      isA<Exception>(),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'login should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
        () => _loginUseCase(
            username: usernameNetException,
            password: passwordNetException,
            notificationToken: ''),
      ).called(1);
    },
    errors: () => [
      isA<NetException>(),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'logout should handle general exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
        () => _logoutUseCase(deviceId: logoutExceptionId),
      ).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'logout should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
        () => _logoutUseCase(deviceId: logoutNetExceptionId),
      ).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Developer login should authenticate successfully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.authenticateDeveloper(
      token: successToken,
      developerId: successId,
    ),
    expect: () => [
      AuthenticationState(
        busy: true,
      ),
      AuthenticationState(
        busy: false,
        user: _activeUser,
        validated: true,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadDeveloperUserDetailsFromTokenUseCase(
          token: successToken,
          developerId: successId,
        ),
      ).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Developer login should handle network errors gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.authenticateDeveloper(
      token: netExceptionToken,
      developerId: netExceptionId,
    ),
    expect: () => [
      AuthenticationState(
        busy: true,
      ),
      AuthenticationState(
        busy: false,
        user: null,
        errorStatus: AuthenticationErrorStatus.network,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadDeveloperUserDetailsFromTokenUseCase(
          token: netExceptionToken,
          developerId: netExceptionId,
        ),
      ).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Developer login should handle exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.authenticateDeveloper(
      token: exceptionToken,
      developerId: exceptionId,
    ),
    expect: () => [
      AuthenticationState(
        busy: true,
      ),
      AuthenticationState(
        busy: false,
        user: null,
        errorStatus: AuthenticationErrorStatus.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadDeveloperUserDetailsFromTokenUseCase(
          token: exceptionToken,
          developerId: exceptionId,
        ),
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
      () => _verifyAccessPinUseCase(pin: correctPin),
    ).thenAnswer(
      (_) async => VerifyPinResponse(
        isVerified: true,
      ),
    );

    when(
      () => _verifyAccessPinUseCase(pin: incorrectPin),
    ).thenAnswer(
      (_) async => VerifyPinResponse(
        isVerified: false,
      ),
    );

    when(
      () => _verifyAccessPinUseCase(pin: exceptionPin),
    ).thenAnswer(
      (_) async => throw Exception(),
    );

    when(
      () => _verifyAccessPinUseCase(pin: netExceptionPin),
    ).thenAnswer(
      (_) async => throw NetException(),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should verify access PIN',
    build: () => AuthenticationCubit(
      updateUserTokenUseCase: _updateUserTokenUseCase,
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _verifyAccessPinUseCase(pin: correctPin)).called(1);
    },
  );
  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set wrong credentials error',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.verifyAccessPin(incorrectPin),
    expect: () => [
      AuthenticationState(busy: true),
      AuthenticationState(
        errorStatus: AuthenticationErrorStatus.wrongCredentials,
      ),
    ],
    verify: (c) {
      verify(() => _verifyAccessPinUseCase(pin: incorrectPin)).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should set PIN needs verification',
    build: () => AuthenticationCubit(
      updateUserTokenUseCase: _updateUserTokenUseCase,
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    seed: AuthenticationState.new,
    act: (c) => c.lock(),
    expect: () => [],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Should lock the user out',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _verifyAccessPinUseCase(pin: exceptionPin)).called(1);
    },
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'verify access pin should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verify(() => _verifyAccessPinUseCase(pin: netExceptionPin)).called(1);
    },
  );
}

void _emptyFieldsTests() {
  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if all fields are empty',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verifyNever(() =>
          _loginUseCase(username: '', password: '', notificationToken: ''));
    },
  ); // should emit empty fields error if all fields are empty

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if username is empty',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verifyNever(() =>
          _loginUseCase(username: '', password: '123', notificationToken: ''));
    },
  ); // should emit empty fields error if username is empty

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit empty fields error if password is empty',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
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
      verifyNever(() => _loginUseCase(
          username: 'superadmin', password: '', notificationToken: ''));
    },
  ); // should emit empty fields error if password is empty
}

void _recoverPassword() {
  final _successUsername = 'user1';
  final _invalidUsername = 'user2';
  final _suspendedUsername = 'user3';
  final _notAllowedUsername = 'user4';
  final _exceptionUsername = 'userERROR';

  setUpAll(() {
    when(
      () => _recoverPasswordUseCase(username: _successUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.success,
    );

    when(
      () => _recoverPasswordUseCase(username: _invalidUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.invalidUser,
    );

    when(
      () => _recoverPasswordUseCase(username: _suspendedUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.suspendedUser,
    );

    when(
      () => _recoverPasswordUseCase(username: _notAllowedUsername),
    ).thenAnswer(
      (_) async => ForgotPasswordRequestStatus.notAllowed,
    );

    when(
      () => _recoverPasswordUseCase(username: _exceptionUsername),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles success',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _recoverPasswordUseCase(username: _successUsername),
    ).called(1),
  ); // Handles success

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles invalid user',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _recoverPasswordUseCase(username: _invalidUsername),
    ).called(1),
  ); // Handles invalid user

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles suspended user',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _recoverPasswordUseCase(username: _suspendedUsername),
    ).called(1),
  ); // Handles suspended user

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Handles recover not allowed',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _recoverPasswordUseCase(username: _notAllowedUsername),
    ).called(1),
  ); // Handles recover not allowed

  blocTest<AuthenticationCubit, AuthenticationState>(
    'Emits error when exception thrown',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _recoverPasswordUseCase(username: _exceptionUsername),
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
      () => _resetPasswordUseCase(
        username: successUsername,
        oldPassword: successOldPassword,
        newPassword: successNewPassword,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _resetPasswordUseCase(
        username: failureUsername,
        oldPassword: failureOldPassword,
        newPassword: failureNewPassword,
      ),
    ).thenAnswer(
      (_) async => false,
    );

    when(
      () => _resetPasswordUseCase(
        username: exceptionUsername,
        oldPassword: exceptionOldPassword,
        newPassword: exceptionNewPassword,
      ),
    ).thenAnswer(
      (_) async => throw Exception(),
    );

    when(
      () => _resetPasswordUseCase(
        username: netExceptionUsername,
        oldPassword: netExceptionOldPassword,
        newPassword: netExceptionNewPassword,
      ),
    ).thenAnswer(
      (_) async => throw NetException(),
    );
  });

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should reset password successfully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _resetPasswordUseCase(
        username: successUsername,
        oldPassword: successOldPassword,
        newPassword: successNewPassword,
      ),
    ).called(1),
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should handle reset password failure gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _resetPasswordUseCase(
        username: failureUsername,
        oldPassword: failureOldPassword,
        newPassword: failureNewPassword,
      ),
    ).called(1),
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should handle general exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _resetPasswordUseCase(
        username: exceptionUsername,
        oldPassword: exceptionOldPassword,
        newPassword: exceptionNewPassword,
      ),
    ).called(1),
    errors: () => [
      isA<Exception>(),
    ],
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should handle network exceptions gracefully',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
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
      () => _resetPasswordUseCase(
        username: netExceptionUsername,
        oldPassword: netExceptionOldPassword,
        newPassword: netExceptionNewPassword,
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

  setUpAll(() {
    when(
      () => _updateUserTokenUseCase(token: 'bearer lmao'),
    ).thenAnswer(
      (_) async => null,
    );
  });
  blocTest<AuthenticationCubit, AuthenticationState>(
    'should emit unlocked state with provided user',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.unlock(user),
    expect: () => [
      AuthenticationState(
        isLocked: false,
        user: user,
      ),
    ],
    verify: (c) => verify(
      () => _updateUserTokenUseCase(
        token: 'bearer lmao',
      ),
    ).called(1),
  );

  blocTest<AuthenticationCubit, AuthenticationState>(
    'should do nothing when locking without authentication',
    build: () => AuthenticationCubit(
      changePasswordUseCase: _changePasswordUseCase,
      loginUseCase: _loginUseCase,
      logoutUseCase: _logoutUseCase,
      recoverPasswordUseCase: _recoverPasswordUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
      verifyAccessPinUseCase: _verifyAccessPinUseCase,
      updateUserTokenUseCase: _updateUserTokenUseCase,
      loadDeveloperUserDetailsFromTokenUseCase:
          _loadDeveloperUserDetailsFromTokenUseCase,
    ),
    act: (c) => c.lock(),
    expect: () => [],
  );
}
