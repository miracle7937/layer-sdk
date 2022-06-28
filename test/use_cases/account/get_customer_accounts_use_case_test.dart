import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepositoryInterface {
}

class MockAccount extends Mock implements Account {}

late MockAccountRepository _repository;
late GetCustomerAccountsUseCase _useCase;
late List<MockAccount> _mockedAccountList;

final _customerId = '1';

void main() {
  setUp(() {
    _repository = MockAccountRepository();
    _useCase = GetCustomerAccountsUseCase(repository: _repository);

    _mockedAccountList = List.generate(
      5,
      (index) => MockAccount(),
    );

    when(
      () => _repository.list(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer((_) async => _mockedAccountList);
  });

  test('Should return a list of accounts', () async {
    final result = await _useCase(customerId: _customerId);

    expect(result, _mockedAccountList);

    verify(
      () => _repository.list(customerId: _customerId),
    ).called(1);
  });
}
