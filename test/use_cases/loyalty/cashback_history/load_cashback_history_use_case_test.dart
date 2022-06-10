import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockCashbackHistoryRepository extends Mock
    implements CashbackHistoryRepositoryInterface {}

class MockCashbackHistory extends Mock implements CashbackHistory {}

late MockCashbackHistoryRepository _repository;
late LoadCashbackHistoryUseCase _useCase;
late MockCashbackHistory _mockedCashbackHistory;

void main() {
  setUp(() {
    _repository = MockCashbackHistoryRepository();
    _useCase = LoadCashbackHistoryUseCase(repository: _repository);

    _mockedCashbackHistory = MockCashbackHistory();

    when(
      () => _repository.getCashbackHistory(),
    ).thenAnswer((_) async => _mockedCashbackHistory);
  });

  test('Should return a cashback history', () async {
    final result = await _useCase();

    expect(result, _mockedCashbackHistory);

    verify(
      () => _repository.getCashbackHistory(),
    ).called(1);
  });
}
