import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCardRepository extends Mock implements CardRepository {}

late MockCardRepository _repo;

final _loadCardsTransactionsId = '1';
final _throwsExceptionId = '2';

final _defaultListData = CardTransactionsListData(
  limit: 10,
);

void main() {
  EquatableConfig.stringify = true;

  final _mockedTransactions = List.generate(
    25,
    (index) => CardTransaction(
      transactionId: index.toString(),
      amount: index,
      description: 'Description $index',
    ),
  );

  setUpAll(() {
    _repo = MockCardRepository();

    /// Test case that retrieves all mocked transactions
    when(
      () => _repo.listCustomerCardTransactions(
        cardId: _loadCardsTransactionsId,
        customerId: _loadCardsTransactionsId,
        limit: _defaultListData.limit,
        offset: 0,
      ),
    ).thenAnswer(
      (_) async => _mockedTransactions.take(_defaultListData.limit).toList(),
    );

    /// Test case that retrives a portion of mocked
    /// transactions between the default limit
    when(
      () => _repo.listCustomerCardTransactions(
        limit: _defaultListData.limit,
        offset: _defaultListData.limit,
        cardId: _loadCardsTransactionsId,
        customerId: _loadCardsTransactionsId,
      ),
    ).thenAnswer(
      (_) async => _mockedTransactions
          .skip(_defaultListData.limit)
          .take(_defaultListData.limit)
          .toList(),
    );

    /// Test case that retrives a portion of mocked
    /// transactions between the default limit
    when(
      () => _repo.listCustomerCardTransactions(
        limit: _defaultListData.limit,
        offset: _defaultListData.limit * 2,
        cardId: _loadCardsTransactionsId,
        customerId: _loadCardsTransactionsId,
      ),
    ).thenAnswer(
      (_) async => _mockedTransactions
          .skip(
            _defaultListData.limit * 2,
          )
          .toList(),
    );

    /// Test case that throws Exception
    when(
      () => _repo.listCustomerCardTransactions(
        cardId: _throwsExceptionId,
        customerId: _throwsExceptionId,
        limit: _defaultListData.limit,
      ),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );
  });

  blocTest<CardTransactionsCubit, CardTransactionsState>(
    'Starts with empty state',
    build: () => CardTransactionsCubit(
      cardId: _loadCardsTransactionsId,
      customerId: _loadCardsTransactionsId,
      repository: _repo,
    ),
    verify: (c) => expect(
      c.state,
      CardTransactionsState(
        customerId: _loadCardsTransactionsId,
        cardId: _loadCardsTransactionsId,
        listData: _defaultListData.copyWith(limit: 50),
      ),
    ),
  );

  blocTest<CardTransactionsCubit, CardTransactionsState>(
    'Load account transactions',
    build: () => CardTransactionsCubit(
      cardId: _loadCardsTransactionsId,
      customerId: _loadCardsTransactionsId,
      repository: _repo,
      limit: _defaultListData.limit,
    ),
    act: (c) => c.load(),
    expect: () => [
      CardTransactionsState(
        busy: true,
        cardId: _loadCardsTransactionsId,
        customerId: _loadCardsTransactionsId,
        listData: _defaultListData,
      ),
      CardTransactionsState(
        customerId: _loadCardsTransactionsId,
        cardId: _loadCardsTransactionsId,
        busy: false,
        transactions: _mockedTransactions.take(_defaultListData.limit).toList(),
        error: CardTransactionsStateErrors.none,
        listData: _defaultListData.copyWith(
          canLoadMore: true,
        ),
      ),
    ],
  );

  blocTest<CardTransactionsCubit, CardTransactionsState>(
    'Loads next page of transactions',
    build: () => CardTransactionsCubit(
      cardId: _loadCardsTransactionsId,
      customerId: _loadCardsTransactionsId,
      repository: _repo,
      limit: _defaultListData.limit,
    ),
    seed: () => CardTransactionsState(
      transactions: _mockedTransactions.take(_defaultListData.limit).toList(),
      customerId: _loadCardsTransactionsId,
      cardId: _loadCardsTransactionsId,
      listData: _defaultListData.copyWith(
        canLoadMore: true,
      ),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      CardTransactionsState(
        busy: true,
        cardId: _loadCardsTransactionsId,
        customerId: _loadCardsTransactionsId,
        transactions: _mockedTransactions.take(_defaultListData.limit).toList(),
        listData: _defaultListData.copyWith(
          canLoadMore: true,
        ),
      ),
      CardTransactionsState(
        customerId: _loadCardsTransactionsId,
        cardId: _loadCardsTransactionsId,
        transactions: _mockedTransactions
            .take(
              _defaultListData.limit * 2,
            )
            .toList(),
        listData: _defaultListData.copyWith(
          canLoadMore: true,
          offset: _defaultListData.limit,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repo.listCustomerCardTransactions(
          cardId: _loadCardsTransactionsId,
          customerId: _loadCardsTransactionsId,
          limit: _defaultListData.limit,
          offset: _defaultListData.limit,
        ),
      ).called(1);
    },
  );

  blocTest<CardTransactionsCubit, CardTransactionsState>(
    'Sets canLoadMore == false when no more items to load',
    build: () => CardTransactionsCubit(
      cardId: _loadCardsTransactionsId,
      customerId: _loadCardsTransactionsId,
      repository: _repo,
      limit: _defaultListData.limit,
    ),
    seed: () => CardTransactionsState(
      transactions: _mockedTransactions
          .take(
            _defaultListData.limit * 2,
          )
          .toList(),
      customerId: _loadCardsTransactionsId,
      cardId: _loadCardsTransactionsId,
      listData: _defaultListData.copyWith(
        canLoadMore: true,
        offset: _defaultListData.limit,
      ),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      CardTransactionsState(
        busy: true,
        cardId: _loadCardsTransactionsId,
        customerId: _loadCardsTransactionsId,
        transactions: _mockedTransactions
            .take(
              _defaultListData.limit * 2,
            )
            .toList(),
        listData: _defaultListData.copyWith(
          canLoadMore: true,
          offset: _defaultListData.limit,
        ),
      ),
      CardTransactionsState(
        customerId: _loadCardsTransactionsId,
        cardId: _loadCardsTransactionsId,
        transactions: _mockedTransactions,
        listData: _defaultListData.copyWith(
          canLoadMore: false,
          offset: _defaultListData.limit * 2,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repo.listCustomerCardTransactions(
          cardId: _loadCardsTransactionsId,
          customerId: _loadCardsTransactionsId,
          limit: _defaultListData.limit,
          offset: _defaultListData.limit * 2,
        ),
      ).called(1);
    },
  );

  blocTest<CardTransactionsCubit, CardTransactionsState>(
    'Handles exceptions gracefully',
    build: () => CardTransactionsCubit(
      cardId: _throwsExceptionId,
      customerId: _throwsExceptionId,
      repository: _repo,
      limit: _defaultListData.limit,
    ),
    act: (c) => c.load(),
    errors: () => [
      isA<Exception>(),
    ],
    expect: () => [
      CardTransactionsState(
        customerId: _throwsExceptionId,
        cardId: _throwsExceptionId,
        busy: true,
        listData: _defaultListData,
        error: CardTransactionsStateErrors.none,
      ),
      CardTransactionsState(
        customerId: _throwsExceptionId,
        cardId: _throwsExceptionId,
        busy: false,
        listData: _defaultListData,
        error: CardTransactionsStateErrors.generic,
      ),
    ],
  );
}
