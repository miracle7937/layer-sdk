import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoyaltyPointsExpirationRepository extends Mock
    implements LoyaltyPointsExpirationRepositoryInterface {}

class MockLoyaltyPointsExpiration extends Mock
    implements LoyaltyPointsExpiration {}

late MockLoyaltyPointsExpirationRepository _repository;
late LoadExpiredLoyaltyPointsByDateUseCase _useCase;
late MockLoyaltyPointsExpiration _mockedLoyaltyPointsExpiration;

final _expirationDate = DateTime.now();

void main() {
  setUp(() {
    _repository = MockLoyaltyPointsExpirationRepository();
    _useCase = LoadExpiredLoyaltyPointsByDateUseCase(repository: _repository);

    _mockedLoyaltyPointsExpiration = MockLoyaltyPointsExpiration();

    when(
      () => _repository.getExpiryPointsByDate(
          expirationDate: any(named: 'expirationDate')),
    ).thenAnswer((_) async => _mockedLoyaltyPointsExpiration);
  });

  test('Should return expired loyalty points', () async {
    final result = await _useCase(expirationDate: _expirationDate);

    expect(result, _mockedLoyaltyPointsExpiration);

    verify(
      () => _repository.getExpiryPointsByDate(expirationDate: _expirationDate),
    ).called(1);
  });
}
