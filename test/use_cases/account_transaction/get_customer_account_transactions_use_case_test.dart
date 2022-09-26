import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';

class MockAccounTransactionRepository extends Mock
    implements AccountTransactionRepositoryInterface {}

class MockAccountTransaction extends Mock implements AccountTransaction {}

late MockAccounTransactionRepository _repository;
late GetCustomerAccountTransactionsUseCase _useCase;
late List<MockAccountTransaction> _mockAccountTransactionList;
final _accountId = '2';

void main() {
  setUp(() {
    _repository = MockAccounTransactionRepository();
    _useCase = GetCustomerAccountTransactionsUseCase(repository: _repository);

    _mockAccountTransactionList = List.generate(
      5,
      (index) => MockAccountTransaction(),
    );

    when(
      () => _repository.listCustomerAccountTransactions(
        accountId: any(named: 'accountId'),
      ),
    ).thenAnswer((_) async => _mockAccountTransactionList);
  });

  test('Should return an account transaction list', () async {
    final result = await _useCase(
      accountId: _accountId,
    );

    expect(result, _mockAccountTransactionList);

    verify(
      () => _repository.listCustomerAccountTransactions(
        accountId: _accountId,
      ),
    ).called(1);
  });
}
