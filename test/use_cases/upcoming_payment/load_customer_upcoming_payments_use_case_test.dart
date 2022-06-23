import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/upcoming_payment.dart';
import 'package:mocktail/mocktail.dart';

class MockUpcomingPaymentRepository extends Mock
    implements UpcomingPaymentRepositoryInterface {}

class MockUpcomingPaymentGroup extends Mock implements UpcomingPaymentGroup {}

late MockUpcomingPaymentRepository _repository;
late LoadCustomerUpcomingPaymentsUseCase _useCase;
late MockUpcomingPaymentGroup _mockedUpcomingPaymentGroup;

final _customerId = '1';

void main() {
  setUp(() {
    _repository = MockUpcomingPaymentRepository();
    _useCase = LoadCustomerUpcomingPaymentsUseCase(repository: _repository);

    _mockedUpcomingPaymentGroup = MockUpcomingPaymentGroup();

    when(
      () => _repository.listAllUpcomingPayments(
        customerID: any(named: 'customerID'),
      ),
    ).thenAnswer((_) async => _mockedUpcomingPaymentGroup);
  });

  test('Should return grouped upcoming payments', () async {
    final result = await _useCase(customerID: _customerId);

    expect(result, _mockedUpcomingPaymentGroup);

    verify(
      () => _repository.listAllUpcomingPayments(
        customerID: _customerId,
      ),
    ).called(1);
  });
}
