import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/checkbook.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckbookRepository extends Mock
    implements CheckbookRepositoryInterface {}

class MockCheckbook extends Mock implements Checkbook {}

late MockCheckbookRepository _repository;
late LoadCustomerCheckbooksUseCase _useCase;
late List<MockCheckbook> _mockedCheckbooks;

final _customerId = '1';

void main() {
  setUp(() {
    _repository = MockCheckbookRepository();
    _useCase = LoadCustomerCheckbooksUseCase(repository: _repository);

    _mockedCheckbooks = List.generate(
      5,
      (index) => MockCheckbook(),
    );

    when(
      () => _repository.list(customerId: any(named: 'customerId')),
    ).thenAnswer((_) async => _mockedCheckbooks);
  });

  test('Should return a checkbook list', () async {
    final result = await _useCase(customerId: _customerId);

    expect(result, _mockedCheckbooks);

    verify(
      () => _repository.list(customerId: _customerId),
    ).called(1);
  });
}
