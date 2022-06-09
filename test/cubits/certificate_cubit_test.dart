import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCertificateRepository extends Mock implements CertificateRepository {}

late MockCertificateRepository _repo;

final _successId = '1';
final _failureId = '2';
final _mockDate = DateTime(2021, 12, 12);

void main() {
  EquatableConfig.stringify = true;

  final mockedCertificateBytes = List.generate(20, (index) => index);

  final successCustomer = Customer(
    id: _successId,
    firstName: 'Mock',
    lastName: 'User',
    type: CustomerType.personal,
  );
  final failureCustomer = Customer(
    id: _failureId,
    firstName: 'Mock',
    lastName: 'User',
    type: CustomerType.personal,
  );

  final successAccount = Account(
    id: _successId,
    accountNumber: 'mock_account_number',
    availableBalance: 999999999999,
  );
  final failureAccount = Account(
    id: _failureId,
    accountNumber: 'mock_account_number',
    availableBalance: 999999999999,
  );

  setUpAll(() {
    _repo = MockCertificateRepository();

    /// Test case that successfully emits a new
    /// certificate of deposit
    when(
      () => _repo.requestCertificateOfDeposit(
        accountId: _successId,
        customerId: _successId,
      ),
    ).thenAnswer((_) async => mockedCertificateBytes);

    /// Test case that fails to emit a new certificate of deposit
    when(
      () => _repo.requestCertificateOfDeposit(
        accountId: _failureId,
        customerId: _failureId,
      ),
    ).thenAnswer((_) async => throw Exception('Some error'));

    /// Test case that successfully emits a new
    /// account certificate
    when(
      () => _repo.requestAccountCertificate(
        accountId: _successId,
        customerId: _successId,
      ),
    ).thenAnswer((_) async => mockedCertificateBytes);

    /// Test case that fails to emit a account certificate
    when(
      () => _repo.requestAccountCertificate(
        accountId: _failureId,
        customerId: _failureId,
      ),
    ).thenAnswer((_) async => throw Exception('Some error'));

    /// Test case that successfully emits a new
    /// account certificate
    when(
      () => _repo.requestBankStatement(
        accountId: _successId,
        customerId: _successId,
        fromDate: _mockDate,
        toDate: _mockDate,
      ),
    ).thenAnswer((_) async => mockedCertificateBytes);

    /// Test case that fails to emit a account certificate
    when(
      () => _repo.requestBankStatement(
        accountId: _failureId,
        customerId: _failureId,
        fromDate: _mockDate,
        toDate: _mockDate,
      ),
    ).thenAnswer((_) async => throw Exception('Some error'));
  });

  blocTest<CertificateCubit, CertificateStates>(
    'Starts with empty state',
    build: () => CertificateCubit(repository: _repo),
    verify: (c) => expect(c.state, CertificateStates()),
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Set customer emits a new state with the provided customer',
    build: () => CertificateCubit(repository: _repo),
    act: (c) => c.setCustomer(successCustomer),
    verify: (c) => expect(
      c.state,
      CertificateStates(
        customer: successCustomer,
      ),
    ),
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Set account emits a new state with the provided account',
    build: () => CertificateCubit(repository: _repo),
    act: (c) => c.setAccount(successAccount),
    verify: (c) => expect(
      c.state,
      CertificateStates(account: successAccount),
    ),
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Request account certificate emits a new state with the file list of bytes',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: successAccount,
      customer: successCustomer,
    ),
    act: (c) => c.requestAccountCertificate(),
    expect: () => [
      CertificateStates(
        account: successAccount,
        customer: successCustomer,
        busy: true,
      ),
      CertificateStates(
        account: successAccount,
        customer: successCustomer,
        certificateBytes: mockedCertificateBytes,
        action: CertificateStatesActions.certificateRequestedSuccessfully,
        busy: false,
      ),
    ],
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Request account certificate emits a new state with failure action',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: failureAccount,
      customer: failureCustomer,
    ),
    act: (c) => c.requestAccountCertificate(),
    expect: () => [
      CertificateStates(
        account: failureAccount,
        customer: failureCustomer,
        busy: true,
      ),
      CertificateStates(
        account: failureAccount,
        customer: failureCustomer,
        action: CertificateStatesActions.certificateRequestFailed,
        busy: false,
      ),
    ],
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Request certificate of deposit emits the file list of bytes',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: successAccount,
      customer: successCustomer,
    ),
    act: (c) => c.requestCertificateOfDeposit(),
    expect: () => [
      CertificateStates(
        account: successAccount,
        customer: successCustomer,
        busy: true,
      ),
      CertificateStates(
        account: successAccount,
        customer: successCustomer,
        certificateBytes: mockedCertificateBytes,
        action: CertificateStatesActions.certificateRequestedSuccessfully,
        busy: false,
      ),
    ],
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Request certificate of deposit emits a new state with failure action',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: failureAccount,
      customer: failureCustomer,
    ),
    act: (c) => c.requestCertificateOfDeposit(),
    expect: () => [
      CertificateStates(
        account: failureAccount,
        customer: failureCustomer,
        busy: true,
      ),
      CertificateStates(
        account: failureAccount,
        customer: failureCustomer,
        action: CertificateStatesActions.certificateRequestFailed,
        busy: false,
      ),
    ],
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Request bank statement emits the file list of bytes',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: successAccount,
      customer: successCustomer,
      startDate: _mockDate,
      endDate: _mockDate,
    ),
    act: (c) => c.requestBankStatement(),
    expect: () => [
      CertificateStates(
        account: successAccount,
        customer: successCustomer,
        startDate: _mockDate,
        endDate: _mockDate,
        busy: true,
      ),
      CertificateStates(
        account: successAccount,
        customer: successCustomer,
        startDate: _mockDate,
        endDate: _mockDate,
        certificateBytes: mockedCertificateBytes,
        action: CertificateStatesActions.certificateRequestedSuccessfully,
        busy: false,
      ),
    ],
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Request bank statement emits a new state with failure action',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: failureAccount,
      customer: failureCustomer,
      startDate: _mockDate,
      endDate: _mockDate,
    ),
    act: (c) => c.requestBankStatement(),
    expect: () => [
      CertificateStates(
        account: failureAccount,
        customer: failureCustomer,
        startDate: _mockDate,
        endDate: _mockDate,
        busy: true,
      ),
      CertificateStates(
        account: failureAccount,
        customer: failureCustomer,
        startDate: _mockDate,
        endDate: _mockDate,
        action: CertificateStatesActions.certificateRequestFailed,
        busy: false,
      ),
    ],
  );

  blocTest<CertificateCubit, CertificateStates>(
    'Clear removes all previous state',
    build: () => CertificateCubit(repository: _repo),
    seed: () => CertificateStates(
      account: failureAccount,
      customer: failureCustomer,
      startDate: _mockDate,
      endDate: _mockDate,
      certificateBytes: mockedCertificateBytes,
    ),
    act: (c) => c.clear(),
    verify: (c) => expect(c.state, CertificateStates()),
  );
}
