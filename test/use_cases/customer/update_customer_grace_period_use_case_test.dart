import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepositoryInterface extends Mock
    implements CustomerRepositoryInterface {}

late MockCustomerRepositoryInterface _repository;
late UpdateCustomerGracePeriodUseCase _useCase;

void main() {
  _repository = MockCustomerRepositoryInterface();
  _useCase = UpdateCustomerGracePeriodUseCase(repository: _repository);

  setUpAll(
    () {
      when(
        () => _repository.updateCustomerGracePeriod(
          customerId: any(named: 'customerId'),
          type: KYCGracePeriodType.id,
        ),
      ).thenAnswer(
        (_) async => true,
      );
    },
  );

  test('Should update customer grace period', () async {
    final result = await _useCase(
      customerId: 'testId',
      type: KYCGracePeriodType.id,
    );

    expect(result, true);
    verify(
      () => _repository.updateCustomerGracePeriod(
        customerId: 'testId',
        type: KYCGracePeriodType.id,
      ),
    ).called(1);
  });
}
