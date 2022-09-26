import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAccountRepository extends Mock
    implements AccountTransactionRepositoryInterface {}

final MockAccountRepository _repo = MockAccountRepository();
final GetCustomerAccountTransactionsUseCase
    _getCustomerAccountTransactionsUseCase =
    GetCustomerAccountTransactionsUseCase(repository: _repo);

final _loadsAccountTransactionsId = '1';
final _throwsExceptionId = '2';
final _defaultLimit = 10;

final _genericException = Exception();

void main() {
  final _mockedTransactions = List.generate(
    25,
    (index) => AccountTransaction(
      transactionId: index.toString(),
      amount: index,
      description: 'Description $index',
    ),
  );

  setUpAll(() {
    /// Test case that retrieves all mocked
    /// transactions between the default limit
    when(
      () => _repo.listCustomerAccountTransactions(
        accountId: _loadsAccountTransactionsId,
        customerId: _loadsAccountTransactionsId,
        limit: _defaultLimit,
        offset: 0,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => _mockedTransactions.take(_defaultLimit).toList());

    /// Test case that retrives a portion of mocked
    /// transactions between the default limit
    when(
      () => _repo.listCustomerAccountTransactions(
        limit: _defaultLimit,
        offset: _defaultLimit,
        accountId: _loadsAccountTransactionsId,
        customerId: _loadsAccountTransactionsId,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async =>
          _mockedTransactions.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    /// Test case that retrives a portion of mocked
    /// transactions between the default limit
    when(
      () => _repo.listCustomerAccountTransactions(
        limit: _defaultLimit,
        offset: _defaultLimit * 2,
        accountId: _loadsAccountTransactionsId,
        customerId: _loadsAccountTransactionsId,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => _mockedTransactions.skip(_defaultLimit * 2).toList(),
    );

    /// Test case that throws Exception
    when(
      () => _repo.listCustomerAccountTransactions(
        accountId: _throwsExceptionId,
        customerId: _throwsExceptionId,
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(_genericException);
  });

  blocTest<AccountTransactionsCubit, AccountTransactionsState>(
    'Starts with empty state',
    build: () => AccountTransactionsCubit(
      getCustomerAccountTransactionsUseCase:
          _getCustomerAccountTransactionsUseCase,
      accountId: _loadsAccountTransactionsId,
      customerId: _loadsAccountTransactionsId,
    ),
    verify: (c) => expect(
      c.state,
      AccountTransactionsState(
        customerId: _loadsAccountTransactionsId,
        accountId: _loadsAccountTransactionsId,
      ),
    ),
  );

  blocTest<AccountTransactionsCubit, AccountTransactionsState>(
    'Load account transactions',
    build: () => AccountTransactionsCubit(
      getCustomerAccountTransactionsUseCase:
          _getCustomerAccountTransactionsUseCase,
      accountId: _loadsAccountTransactionsId,
      customerId: _loadsAccountTransactionsId,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    expect: () => [
      AccountTransactionsState(
        accountId: _loadsAccountTransactionsId,
        customerId: _loadsAccountTransactionsId,
      ),
      AccountTransactionsState(
        customerId: _loadsAccountTransactionsId,
        accountId: _loadsAccountTransactionsId,
        transactions: _mockedTransactions.take(_defaultLimit).toList(),
        errors: {},
        listData: AccountTransactionsListData(
          canLoadMore: true,
        ),
      ),
    ],
  );

  blocTest<AccountTransactionsCubit, AccountTransactionsState>(
    'Loads next page of transactions',
    build: () => AccountTransactionsCubit(
      getCustomerAccountTransactionsUseCase:
          _getCustomerAccountTransactionsUseCase,
      accountId: _loadsAccountTransactionsId,
      customerId: _loadsAccountTransactionsId,
      limit: _defaultLimit,
    ),
    seed: () => AccountTransactionsState(
      transactions: _mockedTransactions.take(_defaultLimit).toList(),
      customerId: _loadsAccountTransactionsId,
      accountId: _loadsAccountTransactionsId,
      listData: AccountTransactionsListData(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      AccountTransactionsState(
        accountId: _loadsAccountTransactionsId,
        customerId: _loadsAccountTransactionsId,
        transactions: _mockedTransactions.take(_defaultLimit).toList(),
        listData: AccountTransactionsListData(canLoadMore: true),
      ),
      AccountTransactionsState(
        customerId: _loadsAccountTransactionsId,
        accountId: _loadsAccountTransactionsId,
        transactions: _mockedTransactions.take(_defaultLimit * 2).toList(),
        listData: AccountTransactionsListData(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
    ],
    verify: (c) {
      verify(() => _repo.listCustomerAccountTransactions(
            accountId: _loadsAccountTransactionsId,
            customerId: _loadsAccountTransactionsId,
            limit: _defaultLimit,
            offset: _defaultLimit,
          )).called(1);
    },
  );

  blocTest<AccountTransactionsCubit, AccountTransactionsState>(
    'Sets canLoadMore == false when no more items to load',
    build: () => AccountTransactionsCubit(
      getCustomerAccountTransactionsUseCase:
          _getCustomerAccountTransactionsUseCase,
      accountId: _loadsAccountTransactionsId,
      customerId: _loadsAccountTransactionsId,
      limit: _defaultLimit,
    ),
    seed: () => AccountTransactionsState(
      transactions: _mockedTransactions.take(_defaultLimit * 2).toList(),
      customerId: _loadsAccountTransactionsId,
      accountId: _loadsAccountTransactionsId,
      listData: AccountTransactionsListData(
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      AccountTransactionsState(
        accountId: _loadsAccountTransactionsId,
        customerId: _loadsAccountTransactionsId,
        transactions: _mockedTransactions.take(_defaultLimit * 2).toList(),
        listData: AccountTransactionsListData(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
      AccountTransactionsState(
        customerId: _loadsAccountTransactionsId,
        accountId: _loadsAccountTransactionsId,
        transactions: _mockedTransactions,
        listData: AccountTransactionsListData(
          canLoadMore: false,
          offset: _defaultLimit * 2,
        ),
      ),
    ],
    verify: (c) {
      verify(() => _repo.listCustomerAccountTransactions(
            accountId: _loadsAccountTransactionsId,
            customerId: _loadsAccountTransactionsId,
            limit: _defaultLimit,
            offset: _defaultLimit * 2,
          )).called(1);
    },
  );

  blocTest<AccountTransactionsCubit, AccountTransactionsState>(
    'Handles exceptions gracefully',
    build: () => AccountTransactionsCubit(
      getCustomerAccountTransactionsUseCase:
          _getCustomerAccountTransactionsUseCase,
      accountId: _throwsExceptionId,
      customerId: _throwsExceptionId,
    ),
    act: (c) => c.load(),
    expect: () => [
      AccountTransactionsState(
        customerId: _throwsExceptionId,
        accountId: _throwsExceptionId,
        transactions: [],
        errors: {},
      ),
      AccountTransactionsState(
        customerId: _throwsExceptionId,
        accountId: _throwsExceptionId,
        transactions: [],
        errors: {},
      ),
    ],
  );
}
