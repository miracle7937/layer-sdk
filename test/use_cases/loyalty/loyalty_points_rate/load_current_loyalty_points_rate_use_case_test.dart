import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoyaltyPointsRateRepository extends Mock
    implements LoyaltyPointsRateRepositoryInterface {}

class MockLoyaltyPointsRate extends Mock implements LoyaltyPointsRate {}

late MockLoyaltyPointsRateRepository _repository;
late LoadCurrentLoyaltyPointsRateUseCase _useCase;
late MockLoyaltyPointsRate _mockedLoyaltyPointsRate;

void main() {
  setUp(() {
    _repository = MockLoyaltyPointsRateRepository();
    _useCase = LoadCurrentLoyaltyPointsRateUseCase(repository: _repository);

    _mockedLoyaltyPointsRate = MockLoyaltyPointsRate();

    when(
      () => _repository.getCurrentRate(),
    ).thenAnswer((_) async => _mockedLoyaltyPointsRate);
  });

  test('Should return the current loyalty points rate', () async {
    final result = await _useCase();

    expect(result, _mockedLoyaltyPointsRate);

    verify(
      () => _repository.getCurrentRate(),
    ).called(1);
  });
}
