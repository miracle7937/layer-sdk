import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/currency.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock
    implements CurrencyRepositoryInterface {}

class MockCurrency extends Mock implements Currency {}

late MockCurrencyRepository _repository;
late LoadAllCurrenciesUseCase _useCase;
late List<MockCurrency> _mockedCurrencyList;

void main() {
  setUp(() {
    _repository = MockCurrencyRepository();
    _useCase = LoadAllCurrenciesUseCase(repository: _repository);

    _mockedCurrencyList = List.generate(
      5,
      (index) => MockCurrency(),
    );

    when(
      () => _repository.list(),
    ).thenAnswer((_) async => _mockedCurrencyList);
  });

  test('Should return a list of currencies', () async {
    final result = await _useCase();

    expect(result, _mockedCurrencyList);

    verify(
      () => _repository.list(),
    ).called(1);
  });
}
