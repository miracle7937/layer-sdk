import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/features/checkbook.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCheckbookRepository extends Mock
    implements CheckbookRepositoryInterface {}

late final _checkbooks = <Checkbook>[];
final _customerId = '112233';
final _repository = MockCheckbookRepository();
final _loadCustomerCheckbooksUseCase =
    LoadCustomerCheckbooksUseCase(repository: _repository);
final _defaultLimit = 10;
final _errorId = '555555';

void main() {
  for (var i = 0; i < 23; i++) {
    _checkbooks.add(Checkbook(
      id: i,
      customerId: _customerId,
      accountId: '356638746723587326',
      checkbookTypeId: '86768575',
    ));
  }

  setUpAll(() {
    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async => _checkbooks.take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
      ),
    ).thenAnswer(
      (_) async => _checkbooks.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 2 * _defaultLimit,
      ),
    ).thenAnswer(
      (_) async => _checkbooks.skip(2 * _defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _errorId,
        limit: _defaultLimit,
        offset: 0,
      ),
    ).thenThrow(
      Exception('Some generic error'),
    );
  });

  blocTest<CheckbookCubit, CheckbookState>(
    'Starts with empty state',
    build: () => CheckbookCubit(
      loadCustomerCheckbooksUseCase: _loadCustomerCheckbooksUseCase,
      customerId: _customerId,
    ),
    verify: (c) => expect(
      c.state,
      CheckbookState(
        customerId: _customerId,
        error: CheckbookStateError.none,
      ),
    ),
  );

  blocTest<CheckbookCubit, CheckbookState>(
    'Should load checkbooks',
    build: () => CheckbookCubit(
      loadCustomerCheckbooksUseCase: _loadCustomerCheckbooksUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    expect: () => [
      CheckbookState(
        customerId: _customerId,
        error: CheckbookStateError.none,
        busy: true,
      ),
      CheckbookState(
        customerId: _customerId,
        checkbooks: _checkbooks.take(_defaultLimit),
        error: CheckbookStateError.none,
        busy: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
        ),
      ).called(1);
    },
  );

  blocTest<CheckbookCubit, CheckbookState>(
    'Should load more checkbooks',
    build: () => CheckbookCubit(
      loadCustomerCheckbooksUseCase: _loadCustomerCheckbooksUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    seed: () => CheckbookState(
      customerId: _customerId,
      checkbooks: _checkbooks.take(_defaultLimit),
    ),
    act: (c) => c.load(
      loadMore: true,
    ),
    expect: () => [
      CheckbookState(
        customerId: _customerId,
        checkbooks: _checkbooks.take(_defaultLimit),
        error: CheckbookStateError.none,
        busy: true,
      ),
      CheckbookState(
        customerId: _customerId,
        checkbooks: _checkbooks.take(2 * _defaultLimit),
        offset: _defaultLimit,
        error: CheckbookStateError.none,
        busy: false,
        canLoadMore: true,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit,
        ),
      ).called(1);
    },
  );

  blocTest<CheckbookCubit, CheckbookState>(
    'Cannnot load more checkbooks on list end',
    build: () => CheckbookCubit(
      loadCustomerCheckbooksUseCase: _loadCustomerCheckbooksUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    seed: () => CheckbookState(
      customerId: _customerId,
      checkbooks: _checkbooks.take(2 * _defaultLimit),
      offset: _defaultLimit,
    ),
    act: (c) => c.load(
      loadMore: true,
    ),
    expect: () => [
      CheckbookState(
        customerId: _customerId,
        checkbooks: _checkbooks.take(2 * _defaultLimit),
        offset: _defaultLimit,
        error: CheckbookStateError.none,
        busy: true,
      ),
      CheckbookState(
        customerId: _customerId,
        checkbooks: _checkbooks,
        offset: 2 * _defaultLimit,
        error: CheckbookStateError.none,
        busy: false,
        canLoadMore: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 2 * _defaultLimit,
        ),
      ).called(1);
    },
  );

  blocTest<CheckbookCubit, CheckbookState>(
    'Should handle errors',
    build: () => CheckbookCubit(
      loadCustomerCheckbooksUseCase: _loadCustomerCheckbooksUseCase,
      customerId: _errorId,
      limit: _defaultLimit,
    ),
    errors: () => [
      isA<Exception>(),
    ],
    act: (c) => c.load(),
    expect: () => [
      CheckbookState(
        customerId: _errorId,
        error: CheckbookStateError.none,
        busy: true,
      ),
      CheckbookState(
        customerId: _errorId,
        error: CheckbookStateError.generic,
        busy: false,
        checkbooks: [],
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _errorId,
          limit: _defaultLimit,
          offset: 0,
        ),
      ).called(1);
    },
  );
}
