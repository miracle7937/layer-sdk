import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/features/accounts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAccountRepository extends Mock implements AccountRepositoryInterface {
}

late MockAccountRepository _repo;
late GetCustomerAccountsUseCase _getCustomerAccountsUseCase;

final _loadAccountsCustomerId = '1';
final _throwsExceptionCustomerId = '2';

void main() {
  final mockedAccounts = List.generate(
    20,
    (index) => Account(
      id: index.toString(),
      accountNumber: index.toString(),
      availableBalance: index,
    ),
  );

  setUpAll(
    () {
      _repo = MockAccountRepository();
      _getCustomerAccountsUseCase =
          GetCustomerAccountsUseCase(repository: _repo);

      /// Test case that retrieves all mocked accounts
      when(
        () => _repo.list(
          customerId: _loadAccountsCustomerId,
        ),
      ).thenAnswer(
        (_) async => mockedAccounts,
      );

      /// Test case that throws Exception
      when(
        () => _repo.list(
          customerId: _throwsExceptionCustomerId,
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some Error'),
      );
    },
  );

  blocTest<AccountCubit, AccountState>(
    'Starts with empty state',
    build: () => AccountCubit(
      getCustomerAccountsUseCase: _getCustomerAccountsUseCase,
      customerId: _loadAccountsCustomerId,
    ),
    verify: (c) => expect(
      c.state,
      AccountState(
        customerId: _loadAccountsCustomerId,
      ),
    ),
  );

  blocTest<AccountCubit, AccountState>(
    'Loads customer accounts',
    build: () => AccountCubit(
      getCustomerAccountsUseCase: _getCustomerAccountsUseCase,
      customerId: _loadAccountsCustomerId,
    ),
    act: (c) => c.load(),
    expect: () => [
      AccountState(
        busy: true,
        customerId: _loadAccountsCustomerId,
      ),
      AccountState(
        accounts: mockedAccounts,
        customerId: _loadAccountsCustomerId,
        error: AccountStateErrors.none,
        busy: false,
      )
    ],
    verify: (c) {
      verify(
        () => _repo.list(
          customerId: _loadAccountsCustomerId,
        ),
      ).called(1);
    },
  );

  blocTest<AccountCubit, AccountState>(
    'Handles exceptions gracefully',
    build: () => AccountCubit(
      getCustomerAccountsUseCase: _getCustomerAccountsUseCase,
      customerId: _throwsExceptionCustomerId,
    ),
    act: (c) => c.load(),
    expect: () => [
      AccountState(
        busy: true,
        customerId: _throwsExceptionCustomerId,
      ),
      AccountState(
        accounts: [],
        error: AccountStateErrors.generic,
        customerId: _throwsExceptionCustomerId,
        busy: false,
      )
    ],
    verify: (c) {
      verify(
        () => _repo.list(
          customerId: _throwsExceptionCustomerId,
        ),
      ).called(1);
    },
  );
}
