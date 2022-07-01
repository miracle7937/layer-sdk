import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepositoryInterface extends Mock
    implements CustomerRepositoryInterface {}

late MockCustomerRepositoryInterface _repository;
late LoadCustomerUseCase _useCase;
late List<Customer> _customers;

void main() {
  _repository = MockCustomerRepositoryInterface();
  _useCase = LoadCustomerUseCase(repository: _repository);

  _customers = List.generate(
    15,
    (index) => Customer(
      id: '$index',
      firstName: 'Name $index',
      status: CustomerStatus.active,
      type: CustomerType.personal,
    ),
  );

  setUpAll(
    () {
      when(
        () => _repository.list(),
      ).thenAnswer(
        (_) async => _customers,
      );
    },
  );

  test('Should returns the correct customers list', () async {
    final result = await _useCase();

    expect(result, _customers);

    verify(
      () => _repository.list(),
    ).called(1);
  });
}
