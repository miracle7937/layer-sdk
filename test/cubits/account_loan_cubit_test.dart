import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

final _repository = MockAccountRepository();

final _successId = '1';
final _failId = '2';
final _limit = 5;

final _successLoandId = 1;
final _failLoanId = 2;

void main() {
  EquatableConfig.stringify = true;

  final mockedLoans = List.generate(
    12,
    (index) => AccountLoan(
      id: index.toString(),
      nextPaymentAmount: 0.0,
      totalAmount: 0.0,
      amountRemaining: 0.0,
      amountRepaid: 0.0,
      paidPayments: 0,
      totalPayments: 0,
    ),
  );

  final successLoan = AccountLoan(
    id: _successLoandId.toString(),
    nextPaymentAmount: 0.0,
    totalAmount: 0.0,
    amountRemaining: 0.0,
    amountRepaid: 0.0,
    paidPayments: 0,
    totalPayments: 0,
  );

  setUpAll(() {
    when(
      () => _repository.listCustomerAccountLoans(
        customerId: _successId,
        forceRefresh: any(named: 'forceRefresh'),
        limit: _limit,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async => mockedLoans.take(_limit).toList(),
    );

    when(
      () => _repository.listCustomerAccountLoans(
        customerId: _failId,
        forceRefresh: any(named: 'forceRefresh'),
        limit: _limit,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );

    when(
      () => _repository.listCustomerAccountLoans(
        customerId: _successId,
        forceRefresh: any(named: 'forceRefresh'),
        limit: _limit,
        offset: _limit,
      ),
    ).thenAnswer(
      (_) async => mockedLoans.skip(_limit).take(_limit).toList(),
    );

    when(
      () => _repository.listCustomerAccountLoans(
        customerId: _successId,
        forceRefresh: any(named: 'forceRefresh'),
        limit: _limit,
        offset: _limit * 2,
      ),
    ).thenAnswer(
      (_) async => mockedLoans.skip(_limit * 2).take(_limit).toList(),
    );

    when(
      () => _repository.listCustomerAccountLoans(
        accountId: '1',
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => mockedLoans.take(_limit).toList(),
    );

    when(
      () => _repository.listCustomerAccountLoans(
        accountId: _failId,
        forceRefresh: any(named: 'forceRefresh'),
        includeDetails: true,
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );

    when(
      () => _repository.getAccountLoan(
        id: _successLoandId,
        forceRefresh: any(named: 'forceRefresh'),
        includeDetails: any(named: 'includeDetails'),
      ),
    ).thenAnswer((_) async => successLoan);

    when(
      () => _repository.getAccountLoan(
        id: _failLoanId,
        forceRefresh: any(named: 'forceRefresh'),
        includeDetails: any(named: 'includeDetails'),
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Starts with empty state',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    verify: (c) => expect(
      c.state,
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
      ),
    ),
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Load retrieves a account loans successfully',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.load(),
    expect: () => [
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: true,
      ),
      AccountLoanState(
        customerId: _successId,
        busy: false,
        loans: mockedLoans.take(_limit),
        error: AccountLoanStateErrors.none,
        canLoadMore: true,
        offset: 0,
        limit: _limit,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          customerId: _successId,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Force load retrieves an account loans successfully',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: true,
      ),
      AccountLoanState(
        customerId: _successId,
        busy: false,
        loans: mockedLoans.take(_limit),
        error: AccountLoanStateErrors.none,
        canLoadMore: true,
        offset: 0,
        limit: _limit,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          customerId: _successId,
          offset: 0,
          limit: _limit,
          forceRefresh: true,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Load emits error when failing to load loans',
    build: () => AccountLoansCubit(
      customerId: _failId,
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.load(),
    expect: () => [
      AccountLoanState(
        customerId: _failId,
        limit: _limit,
        busy: true,
      ),
      AccountLoanState(
        customerId: _failId,
        limit: _limit,
        busy: false,
        loans: [],
        error: AccountLoanStateErrors.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          customerId: _failId,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Load retrieves the next page of account loans successfully',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    seed: () => AccountLoanState(
      customerId: _successId,
      busy: false,
      canLoadMore: true,
      limit: _limit,
      error: AccountLoanStateErrors.none,
      loans: mockedLoans.take(_limit).toList(),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: true,
        canLoadMore: true,
        loans: mockedLoans.take(_limit).toList(),
      ),
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: false,
        loans: mockedLoans.take(_limit * 2).toList(),
        offset: _limit,
        error: AccountLoanStateErrors.none,
        canLoadMore: true,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          customerId: _successId,
          offset: _limit,
          limit: _limit,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Load sets canLoadMore to false when reaching the end of the list',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    seed: () => AccountLoanState(
      customerId: _successId,
      limit: _limit,
      busy: false,
      canLoadMore: true,
      error: AccountLoanStateErrors.none,
      offset: _limit,
      loans: mockedLoans.take(_limit * 2).toList(),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: true,
        canLoadMore: true,
        loans: mockedLoans.take(_limit * 2).toList(),
        offset: _limit,
      ),
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: false,
        loans: mockedLoans,
        offset: _limit * 2,
        error: AccountLoanStateErrors.none,
        canLoadMore: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          customerId: _successId,
          offset: _limit * 2,
          limit: _limit,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Gets a single account loan successfully',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.loadById(id: _successLoandId),
    expect: () => [
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: false,
        loans: [successLoan],
        error: AccountLoanStateErrors.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.getAccountLoan(
          id: _successLoandId,
          includeDetails: true,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Getting a single account loan throws exception',
    build: () => AccountLoansCubit(
      customerId: _successId,
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.loadById(id: _failLoanId),
    expect: () => [
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
      AccountLoanState(
        customerId: _successId,
        limit: _limit,
        busy: false,
        loans: [],
        error: AccountLoanStateErrors.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.getAccountLoan(
          id: _failLoanId,
          includeDetails: true,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Load By Account Ids retrieves all loans successfully',
    build: () => AccountLoansCubit(
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.loadByAccountIds(accountIds: ['1']),
    expect: () => [
      AccountLoanState(
        limit: _limit,
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
      AccountLoanState(
        busy: false,
        limit: _limit,
        loans: mockedLoans.take(5),
        error: AccountLoanStateErrors.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          accountId: '1',
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Force refresh Load By Account Ids retrieves all loans successfully',
    build: () => AccountLoansCubit(
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.loadByAccountIds(accountIds: ['1'], forceRefresh: true),
    expect: () => [
      AccountLoanState(
        limit: _limit,
        busy: true,
        error: AccountLoanStateErrors.none,
      ),
      AccountLoanState(
        busy: false,
        limit: _limit,
        loans: mockedLoans.take(5),
        error: AccountLoanStateErrors.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          accountId: '1',
          includeDetails: true,
          forceRefresh: true,
        ),
      ).called(1);
    },
  );

  blocTest<AccountLoansCubit, AccountLoanState>(
    'Load By Account Ids emits error',
    build: () => AccountLoansCubit(
      limit: _limit,
      repository: _repository,
    ),
    act: (c) => c.loadByAccountIds(accountIds: ['2']),
    expect: () => [
      AccountLoanState(
        limit: _limit,
        busy: true,
      ),
      AccountLoanState(
        limit: _limit,
        busy: false,
        loans: [],
        error: AccountLoanStateErrors.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.listCustomerAccountLoans(
          accountId: _failId,
          forceRefresh: false,
          includeDetails: true,
        ),
      ).called(1);
    },
  );
}
