import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/bills.dart';
import 'package:mocktail/mocktail.dart';

class MockBillRepositoryInterface extends Mock
    implements BillRepositoryInterface {}

late MockBillRepositoryInterface _repository;
late LoadCustomerBillsUseCase _useCase;
late List<Bill> _mockedBills;

void main() {
  setUp(() {
    _repository = MockBillRepositoryInterface();
    _useCase = LoadCustomerBillsUseCase(repository: _repository);

    _mockedBills = List.generate(
      5,
      (index) => Bill(
        nickname: 'Bill $index',
      ),
    );

    when(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer(
      (_) async => _mockedBills,
    );
  });

  test('Should return correct Bills list', () async {
    final result = await _useCase(customerId: 'thisisatest');

    expect(result, _mockedBills);

    verify(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).called(1);
  });
}
