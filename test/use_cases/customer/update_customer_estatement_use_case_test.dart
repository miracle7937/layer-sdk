import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepositoryInterface extends Mock
    implements CustomerRepositoryInterface {}

late MockCustomerRepositoryInterface _repository;
late UpdateCustomerEStatementUseCase _useCase;
bool _value = true;

void main() {
  _repository = MockCustomerRepositoryInterface();
  _useCase = UpdateCustomerEStatementUseCase(repository: _repository);

  setUpAll(
    () {
      when(
        () => _repository.updateCustomerEStatement(
          customerId: any(named: 'customerId'),
          value: _value,
        ),
      ).thenAnswer(
        (_) async => true,
      );
    },
  );

  test('Should update customer e-statement', () async {
    final result = await _useCase(
      customerId: 'testId',
      value: _value,
    );

    expect(result, true);
    verify(
      () => _repository.updateCustomerEStatement(
        customerId: 'testId',
        value: _value,
      ),
    ).called(1);
  });
}
