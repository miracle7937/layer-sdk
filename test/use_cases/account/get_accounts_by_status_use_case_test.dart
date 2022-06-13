import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepositoryInterface {
}

class MockAccount extends Mock implements Account {}

late MockAccountRepository _repository;
late GetAccountsByStatusUseCase _useCase;
late List<MockAccount> _mockedAccountList;

final _statuses = [AccountStatus.active];

void main() {
  setUp(() {
    _repository = MockAccountRepository();
    _useCase = GetAccountsByStatusUseCase(repository: _repository);

    _mockedAccountList = List.generate(
      5,
      (index) => MockAccount(),
    );

    when(
      () => _repository.list(
        statuses: any(named: 'statuses'),
      ),
    ).thenAnswer((_) async => _mockedAccountList);
  });

  test('Should return a list of accounts', () async {
    final result = await _useCase(statuses: _statuses);

    expect(result, _mockedAccountList);

    verify(
      () => _repository.list(statuses: _statuses),
    ).called(1);
  });
}
