import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUpcomingPaymentRepository extends Mock
    implements UpcomingPaymentRepository {}

late MockUpcomingPaymentRepository _repositoryMock;

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
    _repositoryMock = MockUpcomingPaymentRepository();

    when(
      () => _repositoryMock.list(),
    ).thenAnswer((_) async => _payments);

    when(
      () => _repositoryMock.list(
        cardId: _cardId,
      ),
    ).thenAnswer((_) async => _cardPayments);

    when(
      () => _repositoryMock.listAllUpcomingPayments(
        customerID: _customerId,
        limit: _limit,
      ),
    ).thenAnswer((_) async => _paymentsGroup);
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should start on an empty state',
    build: () => UpcomingPaymentCubit(
      repository: _repositoryMock,
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
      repository: _repositoryMock,
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
        () => _repositoryMock.list(),
      ).called(1);
    },
  );

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should load upcoming payments for card id',
    build: () => UpcomingPaymentCubit(
      repository: _repositoryMock,
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
        () => _repositoryMock.list(cardId: _cardId),
      ).called(1);
    },
  );

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should load upcoming payments for customer id',
    build: () => UpcomingPaymentCubit(
      repository: _repositoryMock,
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
        () => _repositoryMock.listAllUpcomingPayments(
          customerID: _customerId,
          limit: _limit,
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
      () => _repositoryMock.list(
        cardId: _wrongCardId,
      ),
    ).thenThrow(_netException);
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should handle net exceptions',
    build: () => UpcomingPaymentCubit(
      repository: _repositoryMock,
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
        () => _repositoryMock.list(cardId: _wrongCardId),
      ).called(1);
    },
  );

  setUp(() {
    when(
      () => _repositoryMock.list(),
    ).thenThrow(_genericException);

    when(
      () => _repositoryMock.list(
        cardId: _wrongCardId,
      ),
    ).thenThrow(_netException);
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should handle generic exceptions',
    build: () => UpcomingPaymentCubit(
      repository: _repositoryMock,
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
        () => _repositoryMock.list(),
      ).called(1);
    },
  );
}
