import 'package:layer_sdk/features/beneficiaries.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBeneficiaryRepositoryInterface extends Mock
    implements BeneficiaryRepositoryInterface {}

late MockBeneficiaryRepositoryInterface _repo;
late Beneficiary _benef;

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

    when(() => _repo.edit(beneficiary: _benef)).thenAnswer(
      (_) async => _benef,
    );
  });

  test('should update the bank', () async {
    final result = await _repo.edit(
      beneficiary: _benef,
    );

    expect(result, _benef);

    verify(() => _repo.edit(beneficiary: _benef)).called(1);
  });
}
