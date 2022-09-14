import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/beneficiaries.dart';
import 'package:mocktail/mocktail.dart';

class MockBeneficiaryRepository extends Mock
    implements BeneficiaryRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockBeneficiaryRepository _repository;
  late AddNewBeneficiaryUseCase _addNewBeneficiaryUseCase;

  final _mockedNewBeneficiary = Beneficiary(
    nickname: 'nickname',
    firstName: 'firstName',
    lastName: 'lastName',
    middleName: 'middleName',
    bankName: 'bankName',
  );
  final _mockedCreatedBeneficiary = _mockedNewBeneficiary.copyWith(id: 1);

  setUp(() {
    _repository = MockBeneficiaryRepository();
    _addNewBeneficiaryUseCase = AddNewBeneficiaryUseCase(
      beneficiaryRepository: _repository,
    );

    when(
      () => _addNewBeneficiaryUseCase(beneficiary: _mockedNewBeneficiary),
    ).thenAnswer(
      (_) async => _mockedCreatedBeneficiary,
    );
  });

  test('Should return newly created beneficiary', () async {
    final response = await _addNewBeneficiaryUseCase(
      beneficiary: _mockedNewBeneficiary,
    );

    expect(response, _mockedCreatedBeneficiary);

    verify(() => _repository.add(beneficiary: _mockedNewBeneficiary));

    verifyNoMoreInteractions(_repository);
  });
}
