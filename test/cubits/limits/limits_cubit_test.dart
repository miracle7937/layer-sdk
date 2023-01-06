import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/domain_layer/models/customer/customer.dart';
import 'package:layer_sdk/domain_layer/models/queue/queue_request.dart';
import 'package:layer_sdk/domain_layer/use_cases/limits/save_limits_use_case.dart';
import 'package:layer_sdk/features/limits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadLimitsUseCase extends Mock implements LoadLimitsUseCase {}

class MockSaveLimitsUseCase extends Mock implements SaveLimitsUseCase {}

late MockLoadLimitsUseCase mockLoadLimitsUseCase;
late MockSaveLimitsUseCase mockSaveLimitsUseCase;

final _failRefresh = true;
final _successRefresh = false;

void main() {
  final _customerId = '65473';
  final _customerType = CustomerType.personal;
  final mockedLimits = Limits(
    minTransferAmount: 1,
    minBillPaymentperTxn: 2,
    minTopupAmountperTxn: 4,
    limWalletBalance: 3,
    limLinkedWalletBalance: 4,
    limCumulativeDaily: 3,
    minRemittanceTransferAmount: 2,
    originalLimitsNotEmpty: true,
    limitsGroups: [],
  );
  final mockedErrorLimits = Limits(
    minTransferAmount: 1,
    minBillPaymentperTxn: 2,
    minTopupAmountperTxn: 3,
    limWalletBalance: 4,
    limLinkedWalletBalance: 5,
    limCumulativeDaily: 6,
    minRemittanceTransferAmount: 7,
    originalLimitsNotEmpty: true,
    limitsGroups: [],
  );

  setUpAll(() {
    mockLoadLimitsUseCase = MockLoadLimitsUseCase();
    mockSaveLimitsUseCase = MockSaveLimitsUseCase();

    when(
      () => mockLoadLimitsUseCase(
        customerId: _customerId,
        forceRefresh: _successRefresh,
      ),
    ).thenAnswer(
      (_) async => mockedLimits,
    );

    when(
      () => mockLoadLimitsUseCase(
          customerId: _customerId, forceRefresh: _failRefresh),
    ).thenAnswer(
      (_) async => throw Exception('Some error'),
    );

    when(
      () => mockSaveLimitsUseCase.call(
        customerId: _customerId,
        customerType: _customerType,
        limits: mockedLimits,
      ),
    ).thenAnswer((invocation) async => QueueRequest());

    when(
      () => mockSaveLimitsUseCase.call(
        customerId: _customerId,
        customerType: _customerType,
        limits: mockedErrorLimits,
      ),
    ).thenAnswer((invocation) async => throw Exception());
  });

  blocTest<LimitsCubit, LimitsState>(
    'starts with empty state',
    build: () => LimitsCubit(
      useCase: mockLoadLimitsUseCase,
      customerId: _customerId,
      customerType: _customerType,
      savelimitsUseCase: mockSaveLimitsUseCase,
    ),
    verify: (c) => expect(
        c.state,
        LimitsState(
          customerId: _customerId,
          customerType: _customerType,
        )),
  );

  blocTest<LimitsCubit, LimitsState>(
    'get Limits retrieves the list of Limits',
    build: () => LimitsCubit(
      customerId: _customerId,
      customerType: _customerType,
      useCase: mockLoadLimitsUseCase,
      savelimitsUseCase: mockSaveLimitsUseCase,
    ),
    act: (c) => c.load(forceRefresh: _successRefresh),
    expect: () => [
      LimitsState(
        busyAction: LimitsBusyAction.load,
        customerId: _customerId,
        customerType: _customerType,
      ),
      LimitsState(
        customerType: _customerType,
        customerId: _customerId,
        busyAction: LimitsBusyAction.none,
        error: LimitsStateError.none,
        limits: mockedLimits,
      ),
    ],
    verify: (c) => verify(
      () => mockLoadLimitsUseCase(
        customerId: _customerId,
        forceRefresh: _successRefresh,
      ),
    ).called(1),
  );

  blocTest<LimitsCubit, LimitsState>(
    'get Limits emits error on failure',
    build: () => LimitsCubit(
      customerId: _customerId,
      savelimitsUseCase: mockSaveLimitsUseCase,
      useCase: mockLoadLimitsUseCase,
      customerType: _customerType,
    ),
    act: (c) => c.load(forceRefresh: _failRefresh),
    expect: () => [
      LimitsState(
        customerId: _customerId,
        customerType: _customerType,
        busyAction: LimitsBusyAction.load,
      ),
      LimitsState(
        error: LimitsStateError.generic,
        customerId: _customerId,
        customerType: _customerType,
        busyAction: LimitsBusyAction.none,
      ),
    ],
    verify: (c) => verify(
      () => mockLoadLimitsUseCase(
        customerId: _customerId,
        forceRefresh: _failRefresh,
      ),
    ).called(1),
  );

  blocTest<LimitsCubit, LimitsState>(
    'saves Limits successfully',
    build: () => LimitsCubit(
      customerId: _customerId,
      customerType: _customerType,
      useCase: mockLoadLimitsUseCase,
      savelimitsUseCase: mockSaveLimitsUseCase,
    ),
    act: (c) => c.save(
        forceRefresh: _successRefresh,
        limits: mockedLimits,
        customerType: _customerType),
    expect: () => [
      LimitsState(
        busyAction: LimitsBusyAction.save,
        customerId: _customerId,
        customerType: _customerType,
      ),
      LimitsState(
        customerType: _customerType,
        customerId: _customerId,
        limits: mockedLimits,
        error: LimitsStateError.none,
      ),
    ],
    verify: (c) => verify(
      () => mockSaveLimitsUseCase(
        customerId: _customerId,
        limits: mockedLimits,
        customerType: _customerType,
      ),
    ).called(1),
  );

  blocTest<LimitsCubit, LimitsState>(
    'save Limits emits error on failure',
    build: () => LimitsCubit(
      customerId: _customerId,
      savelimitsUseCase: mockSaveLimitsUseCase,
      useCase: mockLoadLimitsUseCase,
      customerType: _customerType,
    ),
    act: (c) => c.save(
        forceRefresh: false,
        limits: mockedErrorLimits,
        customerType: _customerType),
    expect: () => [
      LimitsState(
        customerId: _customerId,
        customerType: _customerType,
        busyAction: LimitsBusyAction.save,
      ),
      LimitsState(
        error: LimitsStateError.generic,
        customerId: _customerId,
        customerType: _customerType,
      ),
    ],
    verify: (c) => verify(
      () => mockSaveLimitsUseCase(
        customerId: _customerId,
        limits: mockedErrorLimits,
        customerType: _customerType,
      ),
    ).called(1),
  );
}
