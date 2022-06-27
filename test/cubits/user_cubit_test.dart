import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/features/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadUserByCustomerIdUseCase extends Mock
    implements LoadUserByCustomerIdUseCase {}

class MockRequestLockUseCase extends Mock implements RequestLockUseCase {}

class MockRequestUnlockUseCase extends Mock implements RequestUnlockUseCase {}

class MockRquestActivateUseCase extends Mock implements RequestActivateUseCase {
}

class MockRequestDeactivateUseCase extends Mock
    implements RequestDeactivateUseCase {}

class MockRequestPasswordResetUseCase extends Mock
    implements RequestPasswordResetUseCase {}

class MockRequestPINResetUseCase extends Mock
    implements RequestPINResetUseCase {}

class MockPatchUseRolesUseCase extends Mock implements PatchUserRolesUseCase {}

class MockPathUserBlockedChannlesUseCase extends Mock
    implements PatchUserBlockedChannelUseCase {}

final _loadUserByCustomerIdUseCase = MockLoadUserByCustomerIdUseCase();
final _requestLockUseCase = MockRequestLockUseCase();
final _requestUnlockUseCase = MockRequestUnlockUseCase();
final _requestActivateUseCase = MockRquestActivateUseCase();
final _requestDeactivateUseCase = MockRequestDeactivateUseCase();
final _requestPasswordResetUseCase = MockRequestPasswordResetUseCase();
final _requestPINResetUseCase = MockRequestPINResetUseCase();
final _patchUserRolesUseCase = MockPatchUseRolesUseCase();
final _patchUserBlockedChannelUseCase = MockPathUserBlockedChannlesUseCase();

final _successId = '1';
final _failureId = '2';

final mockUser = User(
  id: _successId,
  firstName: 'Mock',
  lastName: 'User',
);

late UserCubit _successCubit;

late UserCubit _failCubit;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _successCubit = UserCubit(
      customerId: _successId,
      loadUserByCustomerIdUseCase: _loadUserByCustomerIdUseCase,
      requestLockUseCase: _requestLockUseCase,
      requestUnlockUseCase: _requestUnlockUseCase,
      requestActivateUseCase: _requestActivateUseCase,
      requestDeactivateUseCase: _requestDeactivateUseCase,
      requestPasswordResetUseCase: _requestPasswordResetUseCase,
      requestPINResetUseCase: _requestPINResetUseCase,
      patchUserRolesUseCase: _patchUserRolesUseCase,
      patchUserBlockedChannelUseCase: _patchUserBlockedChannelUseCase,
    );

    _failCubit = UserCubit(
      customerId: _failureId,
      loadUserByCustomerIdUseCase: _loadUserByCustomerIdUseCase,
      requestLockUseCase: _requestLockUseCase,
      requestUnlockUseCase: _requestUnlockUseCase,
      requestActivateUseCase: _requestActivateUseCase,
      requestDeactivateUseCase: _requestDeactivateUseCase,
      requestPasswordResetUseCase: _requestPasswordResetUseCase,
      requestPINResetUseCase: _requestPINResetUseCase,
      patchUserRolesUseCase: _patchUserRolesUseCase,
      patchUserBlockedChannelUseCase: _patchUserBlockedChannelUseCase,
    );

    /// getUser() success test case
    when(
      () => _loadUserByCustomerIdUseCase(
        customerID: _successId,
      ),
    ).thenAnswer(
      (_) async => mockUser,
    );

    when(
      () => _loadUserByCustomerIdUseCase(
        customerID: _successId,
        forceRefresh: true,
      ),
    ).thenAnswer(
      (_) async => mockUser,
    );

    /// getUser() failure test case
    when(
      () => _loadUserByCustomerIdUseCase(
        customerID: _failureId,
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<UserCubit, UserState>(
    'Starts with empty state',
    build: () => _successCubit,
    verify: (c) => expect(
      c.state,
      UserState(
        customerId: _successId,
      ),
    ),
  );

  blocTest<UserCubit, UserState>(
    'Load user emits user on success',
    build: () => _successCubit,
    act: (c) => c.loadUser(),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.load},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUserByCustomerIdUseCase(
          customerID: _successId,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Force load user emits user on success',
    build: () => _successCubit,
    act: (c) => c.loadUser(forceRefresh: true),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.load},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUserByCustomerIdUseCase(
          customerID: _successId,
          forceRefresh: true,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Load user emits error on failure',
    build: () => _failCubit,
    act: (c) => c.loadUser(),
    errors: () => [
      isA<Exception>(),
    ],
    expect: () => [
      UserState(
        customerId: _failureId,
        actions: {UserBusyAction.load},
      ),
      UserState(
        customerId: _failureId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUserByCustomerIdUseCase(
          customerID: _failureId,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  group('Lock Tests', _lockTests);
  group('Unlock Tests', _unlockTests);
  group('Activate Tests', _activateTests);
  group('Deactivate Tests', _deactivateTests);
  group('Request Password Tests', _requestPasswordTests);
  group('Request PIN Tests', _requestPINTests);
}

void _lockTests() {
  setUp(() {
    when(
      () => _requestLockUseCase(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request lock emits user on success',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
      user: mockUser,
    ),
    act: (c) => c.requestLock(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        user: mockUser,
        actions: {UserBusyAction.lock},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _requestLockUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
    ),
    act: (c) => c.requestLock(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.lock},
      ),
      UserState(
        customerId: _successId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _requestLockUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}

void _unlockTests() {
  setUp(() {
    when(
      () => _requestUnlockUseCase(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request unlock emits user on success',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
      user: mockUser,
    ),
    act: (c) => c.requestUnlock(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        user: mockUser,
        actions: {UserBusyAction.unlock},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _requestUnlockUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
    ),
    act: (c) => c.requestUnlock(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.unlock},
      ),
      UserState(
        customerId: _successId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _requestUnlockUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}

void _activateTests() {
  setUp(() {
    when(
      () => _requestActivateUseCase(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request activation emits user on success',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
      user: mockUser,
    ),
    act: (c) => c.requestActivate(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        user: mockUser,
        actions: {UserBusyAction.activate},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _requestActivateUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
    ),
    act: (c) => c.requestActivate(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.activate},
      ),
      UserState(
        customerId: _successId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _requestActivateUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}

void _deactivateTests() {
  setUp(() {
    when(
      () => _requestDeactivateUseCase(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request deactivation emits user on success',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
      user: mockUser,
    ),
    act: (c) => c.requestDeactivate(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        user: mockUser,
        actions: {UserBusyAction.deactivate},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _requestDeactivateUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
    ),
    act: (c) => c.requestDeactivate(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.deactivate},
      ),
      UserState(
        customerId: _successId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _requestDeactivateUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}

void _requestPasswordTests() {
  setUp(() {
    when(
      () => _requestPasswordResetUseCase(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request password emits user on success',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
      user: mockUser,
    ),
    act: (c) => c.requestPasswordReset(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        user: mockUser,
        actions: {UserBusyAction.passwordReset},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _requestPasswordResetUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
    ),
    act: (c) => c.requestPasswordReset(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.passwordReset},
      ),
      UserState(
        customerId: _successId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _requestPasswordResetUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}

void _requestPINTests() {
  setUp(() {
    when(
      () => _requestPINResetUseCase(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request PIN reset emits user on success',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
      user: mockUser,
    ),
    act: (c) => c.requestPINReset(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        user: mockUser,
        actions: {UserBusyAction.pinReset},
      ),
      UserState(
        customerId: _successId,
        user: mockUser,
      ),
    ],
    verify: (c) {
      verify(
        () => _requestPINResetUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => _successCubit,
    seed: () => UserState(
      customerId: _successId,
    ),
    act: (c) => c.requestPINReset(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.pinReset},
      ),
      UserState(
        customerId: _successId,
        error: UserStateError.generic,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _requestPINResetUseCase(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}
