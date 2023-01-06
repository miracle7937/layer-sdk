import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock
    implements CustomerRepositoryInterface {}

late LoadCustomerByIdUseCase _useCase;
late MockCustomerRepository _repository;

late Customer _mock;

void main() {
  setUp(() {
    _repository = MockCustomerRepository();
    _useCase = LoadCustomerByIdUseCase(repository: _repository);

    _mock = Customer(
      id: 'thisissomething',
    );

    when(
      () => _repository.getCustomer(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer((_) async => _mock);
  });

  test('Should return correct customer', () async {
    final result = await _useCase(
      customerId: 'ayylmao',
    );

    expect(result, _mock);

    verify(
      () => _repository.getCustomer(customerId: any(named: 'customerId')),
    ).called(1);
  });
}
