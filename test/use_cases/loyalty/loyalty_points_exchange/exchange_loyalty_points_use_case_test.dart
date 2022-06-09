import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoyaltyPointsExchangeRepository extends Mock
    implements LoyaltyPointsExchangeRepositoryInterface {}

class MockLoyaltyPointsExchange extends Mock implements LoyaltyPointsExchange {}

late MockLoyaltyPointsExchangeRepository _repository;
late ExchangeLoyaltyPointsUseCase _useCase;
late MockLoyaltyPointsExchange _mockedLoyaltyPointsExchange;

final _amount = 20;

void main() {
  setUp(() {
    _repository = MockLoyaltyPointsExchangeRepository();
    _useCase = ExchangeLoyaltyPointsUseCase(repository: _repository);

    _mockedLoyaltyPointsExchange = MockLoyaltyPointsExchange();

    when(
      () => _repository.postBurn(amount: any(named: 'amount')),
    ).thenAnswer((_) async => _mockedLoyaltyPointsExchange);
  });

  test('Should return a loyalty points exchange', () async {
    final result = await _useCase(amount: _amount);

    expect(result, _mockedLoyaltyPointsExchange);

    verify(
      () => _repository.postBurn(amount: _amount),
    ).called(1);
  });
}
