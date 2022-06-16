import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/upcoming_payment.dart';
import 'package:mocktail/mocktail.dart';

class MockUpcomingPaymentRepository extends Mock
    implements UpcomingPaymentRepositoryInterface {}

class MockUpcomingPayment extends Mock implements UpcomingPayment {}

late MockUpcomingPaymentRepository _repository;
late GetUpcomingPaymentsUseCase _useCase;
late List<MockUpcomingPayment> _mockedUpcomingPaymentList;

void main() {
  setUp(() {
    _repository = MockUpcomingPaymentRepository();
    _useCase = GetUpcomingPaymentsUseCase(repository: _repository);

    _mockedUpcomingPaymentList = List.generate(
      5,
      (index) => MockUpcomingPayment(),
    );

    when(
      () => _repository.list(),
    ).thenAnswer((_) async => _mockedUpcomingPaymentList);
  });

  test('Should return a list of upcoming payments', () async {
    final result = await _useCase();

    expect(result, _mockedUpcomingPaymentList);

    verify(
      () => _repository.list(),
    ).called(1);
  });
}
