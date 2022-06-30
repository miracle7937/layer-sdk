import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/currency.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyRepository extends Mock
    implements CurrencyRepositoryInterface {}

class MockCurrency extends Mock implements Currency {}

late MockCurrencyRepository _repository;
late LoadCurrencyByCodeUseCase _useCase;
late MockCurrency _mockCurrency;

final _code = 'EUR';

void main() {
  setUp(() {
    _repository = MockCurrencyRepository();
    _useCase = LoadCurrencyByCodeUseCase(repository: _repository);

    _mockCurrency = MockCurrency();

    when(
      () => _repository.getCurrencyByCode(
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async => _mockCurrency);
  });

  test('Should return a currency from a code', () async {
    final result = await _useCase(code: _code);

    expect(result, _mockCurrency);

    verify(
      () => _repository.getCurrencyByCode(code: _code),
    ).called(1);
  });
}
