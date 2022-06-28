import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountLoanRepository extends Mock
    implements AccountLoanRepositoryInterface {}

class MockAccountLoan extends Mock implements AccountLoan {}

late MockAccountLoanRepository _repository;
late GetAccountLoanByIdUseCase _useCase;
late MockAccountLoan _mockAccountLoan;

final _id = 1;

void main() {
  setUp(() {
    _repository = MockAccountLoanRepository();
    _useCase = GetAccountLoanByIdUseCase(repository: _repository);

    _mockAccountLoan = MockAccountLoan();

    when(
      () => _repository.getAccountLoan(
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) async => _mockAccountLoan);
  });

  test('Should return an account loan', () async {
    final result = await _useCase(id: _id);

    expect(result, _mockAccountLoan);

    verify(
      () => _repository.getAccountLoan(id: _id),
    ).called(1);
  });
}
