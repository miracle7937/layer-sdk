import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/beneficiaries.dart';
import 'package:mocktail/mocktail.dart';

class MockBeneficiaryRepositoryInterface extends Mock
    implements BeneficiaryRepositoryInterface {}

late MockBeneficiaryRepositoryInterface _repository;
late LoadCustomerBeneficiariesUseCase _useCase;
late List<Beneficiary> _mockedBeneficiaries;

void main() {
  setUp(() {
    _repository = MockBeneficiaryRepositoryInterface();
    _useCase = LoadCustomerBeneficiariesUseCase(
      beneficiaryRepository: _repository,
    );

    _mockedBeneficiaries = List.generate(
      5,
      (index) => Beneficiary(
        bankName: 'Bank $index',
        firstName: '',
        lastName: '',
        nickname: '',
        middleName: '',
      ),
    );

    when(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer(
      (_) async => _mockedBeneficiaries,
    );
  });

  test('Should return correct beneficiaries list', () async {
    final result = await _useCase(customerId: 'thisisatest');

    expect(result, _mockedBeneficiaries);

    verify(
      () => _repository.list(customerId: any(named: 'customerId')),
    ).called(1);
  });
}
