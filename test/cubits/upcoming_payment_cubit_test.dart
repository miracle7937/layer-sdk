import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/upcoming_payment.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadCustomerUpcomingPaymentsUseCase extends Mock
    implements LoadCustomerUpcomingPaymentsUseCase {}

class MockLoadUpcomingPaymentsUseCase extends Mock
    implements LoadUpcomingPaymentsUseCase {}

late MockLoadCustomerUpcomingPaymentsUseCase
    _loadCustomerUpcomingPaymentsUseCase;
late MockLoadUpcomingPaymentsUseCase _loadUpcomingPaymentsUseCase;

late List<UpcomingPayment> _payments;
late List<UpcomingPayment> _cardPayments;
late UpcomingPaymentGroup _paymentsGroup;

final _cardId = 'cardId';
final _wrongCardId = 'wrongCardId';
final _customerId = '200000';
final _prefCurrency = 'X';

final _total = 33.0;

final _limit = 20;

final _netException = NetException(message: 'Server timed out.');
final _genericException = Exception();

final _defaultState = UpcomingPaymentState(
  customerId: _customerId,
  pagination: Pagination(limit: _limit),
);

void main() {
  EquatableConfig.stringify = true;

  _payments = List.generate(
    5,
    (index) => UpcomingPayment(
      id: index.toString(),
      amount: index.toDouble(),
      currency: _prefCurrency,
    ),
  );

  _cardPayments = _payments.take(2).toList();

  _paymentsGroup = UpcomingPaymentGroup(
    allPayments: _payments,
    prefCurrency: _prefCurrency,
    total: _total,
  );

  setUp(() {
    _loadCustomerUpcomingPaymentsUseCase =
        MockLoadCustomerUpcomingPaymentsUseCase();
    _loadUpcomingPaymentsUseCase = MockLoadUpcomingPaymentsUseCase();

    when(
      () => _loadUpcomingPaymentsUseCase(
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => _payments);

    when(
      () => _loadUpcomingPaymentsUseCase(
        cardId: _cardId,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => _cardPayments);

    when(
      () => _loadCustomerUpcomingPaymentsUseCase(
        customerID: any(named: 'customerID'),
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => _paymentsGroup);
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should start on an empty state',
    build: () => UpcomingPaymentCubit(
      loadCustomerUpcomingPaymentsUseCase: _loadCustomerUpcomingPaymentsUseCase,
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      customerId: _customerId,
      limit: _limit,
    ),
    verify: (c) {
      expect(c.state, _defaultState);
    },
  );

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should load all upcoming payments',
    build: () => UpcomingPaymentCubit(
      loadCustomerUpcomingPaymentsUseCase: _loadCustomerUpcomingPaymentsUseCase,
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      customerId: _customerId,
      limit: _limit,
    ),
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        upcomingPayments: _payments,
        total: _getTotal(_payments),
        currency: _prefCurrency,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUpcomingPaymentsUseCase(),
      ).called(1);
    },
  );

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should load upcoming payments for card id',
    build: () => UpcomingPaymentCubit(
      loadCustomerUpcomingPaymentsUseCase: _loadCustomerUpcomingPaymentsUseCase,
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      customerId: _customerId,
      limit: _limit,
    ),
    act: (c) => c.load(cardId: _cardId),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        upcomingPayments: _cardPayments,
        total: _getTotal(_cardPayments),
        currency: _prefCurrency,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUpcomingPaymentsUseCase(cardId: _cardId),
      ).called(1);
    },
  );

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should load upcoming payments for customer id',
    build: () => UpcomingPaymentCubit(
      loadCustomerUpcomingPaymentsUseCase: _loadCustomerUpcomingPaymentsUseCase,
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      customerId: _customerId,
      limit: _limit,
    ),
    act: (c) => c.loadForCustomer(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        upcomingPayments: _payments,
        total: _total,
        currency: _prefCurrency,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadCustomerUpcomingPaymentsUseCase(
          customerID: _customerId,
          limit: _limit,
          offset: 0,
        ),
      ).called(1);
    },
  );

  group('Test errors', _testErrors);
}

double _getTotal(List<UpcomingPayment> payments) {
  return payments.fold<double>(
    0,
    (amount, payment) => amount + (payment.amount ?? 0),
  );
}

void _testErrors() {
  setUp(() {
    when(
      () => _loadUpcomingPaymentsUseCase(
        cardId: _wrongCardId,
      ),
    ).thenThrow(_netException);
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should handle net exceptions',
    build: () => UpcomingPaymentCubit(
      loadCustomerUpcomingPaymentsUseCase: _loadCustomerUpcomingPaymentsUseCase,
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      customerId: _customerId,
      limit: _limit,
    ),
    act: (c) => c.load(cardId: _wrongCardId),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        errorStatus: UpcomingPaymentErrorStatus.network,
        errorMessage: _netException.message,
        customerId: _customerId,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _loadUpcomingPaymentsUseCase(cardId: _wrongCardId),
      ).called(1);
    },
  );

  setUp(() {
    when(
      () => _loadUpcomingPaymentsUseCase(),
    ).thenThrow(_genericException);

    when(
      () => _loadUpcomingPaymentsUseCase(
        cardId: _wrongCardId,
      ),
    ).thenThrow(_netException);
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should handle generic exceptions',
    build: () => UpcomingPaymentCubit(
      loadCustomerUpcomingPaymentsUseCase: _loadCustomerUpcomingPaymentsUseCase,
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      customerId: _customerId,
      limit: _limit,
    ),
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _customerId,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        errorStatus: UpcomingPaymentErrorStatus.generic,
        customerId: _customerId,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _loadUpcomingPaymentsUseCase(),
      ).called(1);
    },
  );
}
