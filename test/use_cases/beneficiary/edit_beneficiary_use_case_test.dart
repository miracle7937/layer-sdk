import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/features/beneficiaries.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBeneficiaryRepositoryInterface extends Mock
    implements BeneficiaryRepositoryInterface {}

late MockBeneficiaryRepositoryInterface _repo;
late Beneficiary _benef;
late EditBeneficiaryUseCase _useCase;

void main() {
  setUp(() {
    _benef = Beneficiary(
      bankName: 'Banco',
      firstName: 'John',
      lastName: 'Banana',
      middleName: 'Ripe',
      nickname: 'John Cake',
    );

    _repo = MockBeneficiaryRepositoryInterface();
    _useCase = EditBeneficiaryUseCase(beneficiaryRepository: _repo);

    when(() => _repo.edit(beneficiary: _benef)).thenAnswer(
      (_) async => _benef,
    );
  });

  test('should update the bank', () async {
    final result = await _useCase(
      beneficiary: _benef,
    );

    expect(result, _benef);

    verify(() => _repo.edit(beneficiary: _benef)).called(1);
  });
}
