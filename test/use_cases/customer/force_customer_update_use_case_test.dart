import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock
    implements CustomerRepositoryInterface {}

late ForceCustomerUpdateUseCase _useCase;
late MockCustomerRepository _repository;

void main() {
  setUp(() {
    _repository = MockCustomerRepository();
    _useCase = ForceCustomerUpdateUseCase(repository: _repository);

    when(
      () => _repository.forceCustomerUpdate(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer((_) async => true);
  });

  test('Should return correct result', () async {
    final result = await _useCase(
      customerId: 'customerId',
    );

    expect(result, true);

    verify(
      () => _repository.forceCustomerUpdate(customerId: 'customerId'),
    ).called(1);
  });
}
