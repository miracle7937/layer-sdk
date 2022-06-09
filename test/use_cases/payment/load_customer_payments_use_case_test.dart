import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/payments.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentsRepositoryInterface extends Mock
    implements PaymentsRepositoryInterface {}

late MockPaymentsRepositoryInterface _repository;
late LoadCustomerPaymentsUseCase _useCase;
late List<Payment> _mockedPayments;

void main() {
  setUp(() {
    _repository = MockPaymentsRepositoryInterface();
    _useCase = LoadCustomerPaymentsUseCase(repository: _repository);

    _mockedPayments = List.generate(
      5,
      (index) => Payment(
        id: index,
      ),
    );

    when(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer(
      (_) async => _mockedPayments,
    );
  });

  test('Should return correct Payments list', () async {
    final result = await _useCase(customerId: 'thisisatest');

    expect(result, _mockedPayments);

    verify(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).called(1);
  });
}
