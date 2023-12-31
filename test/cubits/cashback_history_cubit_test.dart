import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCashbackHistoryRepository extends Mock
    implements CashbackHistoryRepositoryInterface {}

void main() {
  late CashbackHistoryRepositoryInterface repositoryMock;
  late LoadCashbackHistoryUseCase _loadCashbackHistoryUseCase;

  final history = CashbackHistory();
  final to = DateTime.now();
  final from = to.subtract(Duration(days: 365));

  final _netException = NetException(message: 'Server timed out');
  final _genericException = Exception();

  setUp(() {
    repositoryMock = MockCashbackHistoryRepository();
    _loadCashbackHistoryUseCase =
        LoadCashbackHistoryUseCase(repository: repositoryMock);

    when(
      () => repositoryMock.getCashbackHistory(
        from: from,
        to: to,
      ),
    ).thenAnswer((_) async => history);

    when(
      () => repositoryMock.getCashbackHistory(
        from: from,
      ),
    ).thenThrow(_netException);

    when(
      () => repositoryMock.getCashbackHistory(
        to: to,
      ),
    ).thenThrow(_genericException);
  });

  blocTest<CashbackHistoryCubit, CashbackHistoryState>(
    'Should start on an empty state',
    build: () => CashbackHistoryCubit(
      loadCashbackHistoryUseCase: _loadCashbackHistoryUseCase,
    ),
    verify: (c) => expect(c.state, CashbackHistoryState()),
  );

  blocTest<CashbackHistoryCubit, CashbackHistoryState>(
    'Should load cashback history',
    build: () => CashbackHistoryCubit(
      loadCashbackHistoryUseCase: _loadCashbackHistoryUseCase,
    ),
    act: (c) => c.load(
      from: from,
      to: to,
    ),
    expect: () => [
      CashbackHistoryState(
        busy: true,
        error: CashbackHistoryStateError.none,
      ),
      CashbackHistoryState(cashbackHistory: history),
    ],
    verify: (c) {
      verify(() => repositoryMock.getCashbackHistory(
            from: from,
            to: to,
          )).called(1);
      verifyNoMoreInteractions(repositoryMock);
    },
  );

  blocTest<CashbackHistoryCubit, CashbackHistoryState>(
    'Should handle NetException',
    build: () => CashbackHistoryCubit(
      loadCashbackHistoryUseCase: _loadCashbackHistoryUseCase,
    ),
    act: (c) => c.load(from: from),
    expect: () => [
      CashbackHistoryState(
        busy: true,
        error: CashbackHistoryStateError.none,
      ),
      CashbackHistoryState(
        error: CashbackHistoryStateError.network,
        errorMessage: _netException.message,
      ),
    ],
    verify: (c) {
      verify(() => repositoryMock.getCashbackHistory(
            from: from,
          )).called(1);
      verifyNoMoreInteractions(repositoryMock);
    },
  );

  blocTest<CashbackHistoryCubit, CashbackHistoryState>(
    'Should handle Exception',
    build: () => CashbackHistoryCubit(
      loadCashbackHistoryUseCase: _loadCashbackHistoryUseCase,
    ),
    act: (c) => c.load(to: to),
    expect: () => [
      CashbackHistoryState(
        busy: true,
        error: CashbackHistoryStateError.none,
      ),
      CashbackHistoryState(
        error: CashbackHistoryStateError.generic,
      ),
    ],
    verify: (c) {
      verify(() => repositoryMock.getCashbackHistory(
            to: to,
          )).called(1);
      verifyNoMoreInteractions(repositoryMock);
    },
  );
}
