import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/features/audit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuditRepository extends Mock implements AuditRepositoryInterface {}

late MockAuditRepository _repository;
late LoadCustomerAuditsUseCase _loadCustomerAuditsUseCase;
final _customerId = '123456';
final _defaultLimit = 10;
final _searchText = '9';
final _repositoryList = <Audit>[];
final _total = 23;
final _genericErrorId = '7331';

void main() {
  for (var i = 0; i < _total; i++) {
    _repositoryList.add(Audit(
      auditId: i,
      countTotal: _total,
    ));
  }

  setUpAll(() {
    _repository = MockAuditRepository();
    _loadCustomerAuditsUseCase =
        LoadCustomerAuditsUseCase(repository: _repository);

    when(
      () => _repository.listCustomerAudits(
        limit: _defaultLimit,
        offset: 0,
        searchText: null,
        customerId: _customerId,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.take(_defaultLimit).toList(),
    );

    when(
      () => _repository.listCustomerAudits(
        limit: _defaultLimit,
        offset: _defaultLimit,
        customerId: _customerId,
      ),
    ).thenAnswer(
      (_) async =>
          _repositoryList.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    when(
      () => _repository.listCustomerAudits(
        limit: _defaultLimit,
        offset: 2 * _defaultLimit,
        customerId: _customerId,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.skip(2 * _defaultLimit).toList(),
    );

    when(
      () => _repository.listCustomerAudits(
        limit: _defaultLimit,
        offset: 0,
        customerId: _customerId,
        searchText: _searchText,
      ),
    ).thenAnswer(
      (_) async => _repositoryList
          .where(
            (audit) => audit.auditId.toString().contains(
                  _searchText,
                ),
          )
          .take(_defaultLimit)
          .toList(),
    );

    when(
      () => _repository.listCustomerAudits(
        limit: _defaultLimit,
        offset: 0,
        customerId: _genericErrorId,
      ),
    ).thenThrow(
      Exception('Some generic error'),
    );
  });

  blocTest<CustomerAuditsCubit, CustomerAuditsState>(
    'Starts on empty state',
    build: () => CustomerAuditsCubit(
      loadCustomerAuditsUseCase: _loadCustomerAuditsUseCase,
      customerId: _customerId,
    ),
    verify: (c) => expect(
      c.state,
      CustomerAuditsState(
        customerId: _customerId,
      ),
    ),
  );

  blocTest<CustomerAuditsCubit, CustomerAuditsState>(
    'Should load audits',
    build: () => CustomerAuditsCubit(
      loadCustomerAuditsUseCase: _loadCustomerAuditsUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    expect: () => [
      CustomerAuditsState(
        customerId: _customerId,
        busy: true,
        error: CustomerAuditsStateError.none,
      ),
      CustomerAuditsState(
        customerId: _customerId,
        audits: _repositoryList.take(_defaultLimit),
        busy: false,
        error: CustomerAuditsStateError.none,
      ),
    ],
    verify: (c) => verify(
      () => _repository.listCustomerAudits(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
      ),
    ).called(1),
  );

  blocTest<CustomerAuditsCubit, CustomerAuditsState>(
    'Should load more audits',
    build: () => CustomerAuditsCubit(
      loadCustomerAuditsUseCase: _loadCustomerAuditsUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    seed: () => CustomerAuditsState(
      customerId: _customerId,
      audits: _repositoryList.take(_defaultLimit),
    ),
    act: (c) => c.load(
      loadMore: true,
    ),
    expect: () => [
      CustomerAuditsState(
        customerId: _customerId,
        busy: true,
        error: CustomerAuditsStateError.none,
        audits: _repositoryList.take(_defaultLimit),
      ),
      CustomerAuditsState(
        customerId: _customerId,
        audits: _repositoryList.take(2 * _defaultLimit),
        offset: _defaultLimit,
        busy: false,
        error: CustomerAuditsStateError.none,
      ),
    ],
    verify: (c) => verify(
      () => _repository.listCustomerAudits(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
      ),
    ).called(1),
  );

  blocTest<CustomerAuditsCubit, CustomerAuditsState>(
    'Cannot load more on list end',
    build: () => CustomerAuditsCubit(
      loadCustomerAuditsUseCase: _loadCustomerAuditsUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    seed: () => CustomerAuditsState(
      customerId: _customerId,
      audits: _repositoryList.take(2 * _defaultLimit),
      offset: _defaultLimit,
    ),
    act: (c) => c.load(
      loadMore: true,
    ),
    expect: () => [
      CustomerAuditsState(
        customerId: _customerId,
        busy: true,
        error: CustomerAuditsStateError.none,
        audits: _repositoryList.take(2 * _defaultLimit),
        offset: _defaultLimit,
      ),
      CustomerAuditsState(
        customerId: _customerId,
        audits: _repositoryList,
        offset: 2 * _defaultLimit,
        busy: false,
        error: CustomerAuditsStateError.none,
        canLoadMore: false,
      ),
    ],
    verify: (c) => verify(
      () => _repository.listCustomerAudits(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 2 * _defaultLimit,
      ),
    ).called(1),
  );

  blocTest<CustomerAuditsCubit, CustomerAuditsState>(
    'Should search audits',
    build: () => CustomerAuditsCubit(
      loadCustomerAuditsUseCase: _loadCustomerAuditsUseCase,
      customerId: _customerId,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(
      searchText: _searchText,
    ),
    expect: () => [
      CustomerAuditsState(
        customerId: _customerId,
        busy: true,
        error: CustomerAuditsStateError.none,
      ),
      CustomerAuditsState(
        customerId: _customerId,
        audits: _repositoryList
            .where(
              (audit) => audit.auditId.toString().contains(
                    _searchText,
                  ),
            )
            .take(_defaultLimit),
        busy: false,
        error: CustomerAuditsStateError.none,
        canLoadMore: false,
      ),
    ],
    verify: (c) => verify(
      () => _repository.listCustomerAudits(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
        searchText: _searchText,
      ),
    ).called(1),
  );

  blocTest<CustomerAuditsCubit, CustomerAuditsState>(
    'Should handle exceptions',
    build: () => CustomerAuditsCubit(
      loadCustomerAuditsUseCase: _loadCustomerAuditsUseCase,
      customerId: _genericErrorId,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    errors: () => [
      isA<Exception>(),
    ],
    expect: () => [
      CustomerAuditsState(
        customerId: _genericErrorId,
        busy: true,
        error: CustomerAuditsStateError.none,
      ),
      CustomerAuditsState(
        customerId: _genericErrorId,
        busy: false,
        error: CustomerAuditsStateError.generic,
        audits: [],
      ),
    ],
    verify: (c) => verify(
      () => _repository.listCustomerAudits(
        customerId: _genericErrorId,
        limit: _defaultLimit,
        offset: 0,
      ),
    ).called(1),
  );
}
