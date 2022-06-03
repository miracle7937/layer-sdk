import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

late MockAccountRepository _repo;

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

      /// Test case that retrieves all mocked accounts
      when(
        () => _repo.listCustomerAccounts(
          customerId: _loadAccountsCustomerId,
        ),
      ).thenAnswer(
        (_) async => mockedAccounts,
      );

      /// Test case that throws Exception
      when(
        () => _repo.listCustomerAccounts(
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
      repository: _repo,
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
      repository: _repo,
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
        () => _repo.listCustomerAccounts(
          customerId: _loadAccountsCustomerId,
        ),
      ).called(1);
    },
  );

  blocTest<AccountCubit, AccountState>(
    'Handles exceptions gracefully',
    build: () => AccountCubit(
      repository: _repo,
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
        () => _repo.listCustomerAccounts(
          customerId: _throwsExceptionCustomerId,
        ),
      ).called(1);
    },
  );
}
