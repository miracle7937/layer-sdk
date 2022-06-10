import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountLoanRepository extends Mock
    implements AccountLoanRepositoryInterface {}

class MockAccountLoan extends Mock implements AccountLoan {}

late MockAccountLoanRepository _repository;
late GetAccountLoansUseCase _useCase;
late List<MockAccountLoan> _mockAccountLoanList;

final _accountId = '1';

void main() {
  setUp(() {
    _repository = MockAccountLoanRepository();
    _useCase = GetAccountLoansUseCase(repository: _repository);

    _mockAccountLoanList = List.generate(
      5,
      (index) => MockAccountLoan(),
    );

    when(
      () => _repository.listCustomerAccountLoans(
        accountId: any(named: 'accountId'),
      ),
    ).thenAnswer((_) async => _mockAccountLoanList);
  });

  test('Should return an account loan list', () async {
    final result = await _useCase(accountId: _accountId);

    expect(result, _mockAccountLoanList);

    verify(
      () => _repository.listCustomerAccountLoans(accountId: _accountId),
    ).called(1);
  });
}
