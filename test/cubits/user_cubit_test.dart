import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository {}

final _repository = MockUserRepository();

final _successId = '1';
final _failureId = '2';

final mockUser = User(
  id: _successId,
  firstName: 'Mock',
  lastName: 'User',
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    /// getUser() success test case
    when(
      () => _repository.getUser(
        customerID: _successId,
      ),
    ).thenAnswer(
      (_) async => mockUser,
    );

    when(
      () => _repository.getUser(
        customerID: _successId,
        forceRefresh: true,
      ),
    ).thenAnswer(
      (_) async => mockUser,
    );

    /// getUser() failure test case
    when(
      () => _repository.getUser(
        customerID: _failureId,
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<UserCubit, UserState>(
    'Starts with empty state',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
    verify: (c) => expect(
      c.state,
      UserState(
        customerId: _successId,
      ),
    ),
  );

  blocTest<UserCubit, UserState>(
    'Load user emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.getUser(
          customerID: _successId,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Force load user emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.getUser(
          customerID: _successId,
          forceRefresh: true,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Load user emits error on failure',
    build: () => UserCubit(
      repository: _repository,
      customerId: _failureId,
    ),
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
        () => _repository.getUser(
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
      () => _repository.requestLock(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request lock emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestLock(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestLock(
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
      () => _repository.requestUnlock(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request unlock emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestUnlock(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestUnlock(
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
      () => _repository.requestActivate(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request activation emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestActivate(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestActivate(
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
      () => _repository.requestDeactivate(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request deactivation emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestDeactivate(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestDeactivate(
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
      () => _repository.requestPasswordReset(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request password emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestPasswordReset(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestPasswordReset(
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
      () => _repository.requestPINReset(
        userId: mockUser.id,
        customerType: CustomerType.personal,
      ),
    ).thenAnswer((_) async => mockUser);
  });

  blocTest<UserCubit, UserState>(
    'Request PIN reset emits user on success',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestPINReset(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      ).called(1);
    },
  );

  blocTest<UserCubit, UserState>(
    'Error correctly emitted if no user is loaded.',
    build: () => UserCubit(
      repository: _repository,
      customerId: _successId,
    ),
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
        () => _repository.requestPINReset(
          userId: mockUser.id,
          customerType: CustomerType.personal,
        ),
      );
    },
  );
}
