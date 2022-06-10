import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoyaltyPointsRepository extends Mock
    implements LoyaltyPointsRepositoryInterface {}

class MockLoyaltyPoints extends Mock implements LoyaltyPoints {}

late MockLoyaltyPointsRepository _repository;
late LoadAllLoyaltyPointsUseCase _useCase;
late List<MockLoyaltyPoints> _mockedLoyaltyPoints;

void main() {
  setUp(() {
    _repository = MockLoyaltyPointsRepository();
    _useCase = LoadAllLoyaltyPointsUseCase(repository: _repository);

    _mockedLoyaltyPoints = List.generate(
      5,
      (index) => MockLoyaltyPoints(),
    );

    when(
      () => _repository.listAllLoyaltyPoints(),
    ).thenAnswer((_) async => _mockedLoyaltyPoints);
  });

  test('Should return a loyalty points list', () async {
    final result = await _useCase();

    expect(result, _mockedLoyaltyPoints);

    verify(
      () => _repository.listAllLoyaltyPoints(),
    ).called(1);
  });
}
