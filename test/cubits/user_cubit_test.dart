import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/features/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadUserByCustomerIdUseCase extends Mock
    implements LoadUsersByCustomerIdUseCase {}

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

class MockDeleteAgentUseCase extends Mock implements DeleteAgentUseCase {}

class MockPathUserBlockedChannlesUseCase extends Mock
    implements PatchUserBlockedChannelUseCase {}

final _loadUsersByCustomerIdUseCase = MockLoadUserByCustomerIdUseCase();
final _requestLockUseCase = MockRequestLockUseCase();
final _requestUnlockUseCase = MockRequestUnlockUseCase();
final _requestActivateUseCase = MockRquestActivateUseCase();
final _requestDeactivateUseCase = MockRequestDeactivateUseCase();
final _requestPasswordResetUseCase = MockRequestPasswordResetUseCase();
final _requestPINResetUseCase = MockRequestPINResetUseCase();
final _patchUserRolesUseCase = MockPatchUseRolesUseCase();
final _patchUserBlockedChannelUseCase = MockPathUserBlockedChannlesUseCase();
final _deleteAgentUseCase = MockDeleteAgentUseCase();

final _successId = '1';
final _failureId = '2';

final mockUser = User(
  id: 'userId1',
  firstName: 'MockUserFirstName1',
  lastName: 'MockUserLastName1',
  created: DateTime.utc(2020),
);

final mockUser1 = User(
  id: 'userId2',
  firstName: 'MockUserFirstName2',
  lastName: 'MockUserLastName2',
  created: DateTime.utc(2021),
);

final mockUser2 = User(
  id: 'finalId',
  firstName: 'finalFN',
  lastName: 'finalLN',
  created: DateTime.utc(2022),
);

late UserCubit _successCubit;

late UserCubit _failCubit;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _successCubit = UserCubit(
      customerId: _successId,
      loadUserByCustomerIdUseCase: _loadUsersByCustomerIdUseCase,
      requestLockUseCase: _requestLockUseCase,
      requestUnlockUseCase: _requestUnlockUseCase,
      requestActivateUseCase: _requestActivateUseCase,
      requestDeactivateUseCase: _requestDeactivateUseCase,
      requestPasswordResetUseCase: _requestPasswordResetUseCase,
      requestPINResetUseCase: _requestPINResetUseCase,
      patchUserRolesUseCase: _patchUserRolesUseCase,
      patchUserBlockedChannelUseCase: _patchUserBlockedChannelUseCase,
      deleteAgentUseCase: _deleteAgentUseCase,
    );

    _failCubit = UserCubit(
      customerId: _failureId,
      loadUserByCustomerIdUseCase: _loadUsersByCustomerIdUseCase,
      requestLockUseCase: _requestLockUseCase,
      requestUnlockUseCase: _requestUnlockUseCase,
      requestActivateUseCase: _requestActivateUseCase,
      requestDeactivateUseCase: _requestDeactivateUseCase,
      requestPasswordResetUseCase: _requestPasswordResetUseCase,
      requestPINResetUseCase: _requestPINResetUseCase,
      patchUserRolesUseCase: _patchUserRolesUseCase,
      patchUserBlockedChannelUseCase: _patchUserBlockedChannelUseCase,
      deleteAgentUseCase: _deleteAgentUseCase,
    );

    /// getUser() success test case
    when(
      () => _loadUsersByCustomerIdUseCase(
        customerID: _successId,
        name: '',
      ),
    ).thenAnswer(
      (_) async => [mockUser, mockUser1],
    );

    when(
      () => _loadUsersByCustomerIdUseCase(
        customerID: _successId,
        forceRefresh: true,
        name: '',
      ),
    ).thenAnswer(
      (_) async => [mockUser, mockUser1],
    );

    /// getUser() failure test case
    when(
      () => _loadUsersByCustomerIdUseCase(
        customerID: _failureId,
        name: '',
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
    'Load users emits user on success',
    build: () => _successCubit,
    act: (c) => c.load(),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.load},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser, mockUser1],
        listData: UserListData(
          canLoadMore: false,
          searchString: '',
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUsersByCustomerIdUseCase(
          customerID: _successId,
          forceRefresh: false,
          name: '',
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Force load user emits user on success',
    build: () => _successCubit,
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      UserState(
        customerId: _successId,
        actions: {UserBusyAction.load},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser, mockUser1],
        listData: UserListData(
          canLoadMore: false,
          searchString: '',
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUsersByCustomerIdUseCase(
          customerID: _successId,
          forceRefresh: true,
          name: '',
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Load users emits error on failure',
    build: () => _failCubit,
    act: (c) => c.load(),
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
        () => _loadUsersByCustomerIdUseCase(
          customerID: _failureId,
          forceRefresh: false,
          name: '',
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
      users: [mockUser],
    ),
    act: (c) => c.requestLock(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        users: [mockUser],
        actions: {UserBusyAction.lock},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser],
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
      users: [mockUser],
    ),
    act: (c) => c.requestUnlock(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        users: [mockUser],
        actions: {UserBusyAction.unlock},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser],
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
      users: [mockUser],
    ),
    act: (c) => c.requestActivate(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        users: [mockUser],
        actions: {UserBusyAction.activate},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser],
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
      users: [mockUser],
    ),
    act: (c) => c.requestDeactivate(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        users: [mockUser],
        actions: {UserBusyAction.deactivate},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser],
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
      users: [mockUser],
    ),
    act: (c) => c.requestPasswordReset(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        users: [mockUser],
        actions: {UserBusyAction.passwordReset},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser],
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
      users: [mockUser],
    ),
    act: (c) => c.requestPINReset(
      customerType: CustomerType.personal,
    ),
    expect: () => [
      UserState(
        customerId: _successId,
        users: [mockUser],
        actions: {UserBusyAction.pinReset},
      ),
      UserState(
        customerId: _successId,
        users: [mockUser],
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
