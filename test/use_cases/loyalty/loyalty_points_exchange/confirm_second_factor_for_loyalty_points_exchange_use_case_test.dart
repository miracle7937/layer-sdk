import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoyaltyPointsExchangeRepository extends Mock
    implements LoyaltyPointsExchangeRepositoryInterface {}

class MockLoyaltyPointsExchange extends Mock implements LoyaltyPointsExchange {}

late MockLoyaltyPointsExchangeRepository _repository;
late ConfirmSecondFactorForLoyaltyPointsExchangeUseCase _useCase;
late MockLoyaltyPointsExchange _mockedLoyaltyPointsExchange;

final _transactionId = '1';

void main() {
  setUp(() {
    _repository = MockLoyaltyPointsExchangeRepository();
    _useCase = ConfirmSecondFactorForLoyaltyPointsExchangeUseCase(
        repository: _repository);

    _mockedLoyaltyPointsExchange = MockLoyaltyPointsExchange();

    when(
      () => _repository.postSecondFactor(
          transactionId: any(named: 'transactionId')),
    ).thenAnswer((_) async => _mockedLoyaltyPointsExchange);
  });

  test('Should return a loyalty points exchange', () async {
    final result = await _useCase(transactionId: _transactionId);

    expect(result, _mockedLoyaltyPointsExchange);

    verify(
      () => _repository.postSecondFactor(transactionId: _transactionId),
    ).called(1);
  });
}
