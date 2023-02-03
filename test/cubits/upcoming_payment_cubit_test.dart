import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/upcoming_payment.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadUpcomingPaymentsUseCase extends Mock
    implements LoadUpcomingPaymentsUseCase {}

late MockLoadUpcomingPaymentsUseCase _loadUpcomingPaymentsUseCase;

late List<UpcomingPayment> _payments;
late List<UpcomingPayment> _cardPayments;

final _cardId = 'cardId';
final _wrongCardId = 'wrongCardId';
final _prefCurrency = 'X';

final _limit = 20;

final _netException = NetException(message: 'Server timed out.');
final _genericException = Exception();

final _defaultState = UpcomingPaymentState(
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

  setUp(() {
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
  });

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should start on an empty state',
    build: () => UpcomingPaymentCubit(
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      limit: _limit,
    ),
    verify: (c) {
      expect(c.state, _defaultState);
    },
  );

  blocTest<UpcomingPaymentCubit, UpcomingPaymentState>(
    'Should load all upcoming payments',
    build: () => UpcomingPaymentCubit(
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      limit: _limit,
    ),
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        upcomingPayments: _payments,
        total: _getTotal(_payments),
        currency: _prefCurrency,
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
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      limit: _limit,
    ),
    act: (c) => c.load(cardId: _cardId),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        upcomingPayments: _cardPayments,
        total: _getTotal(_cardPayments),
        currency: _prefCurrency,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUpcomingPaymentsUseCase(cardId: _cardId),
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
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      limit: _limit,
    ),
    act: (c) => c.load(cardId: _wrongCardId),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        errorStatus: UpcomingPaymentErrorStatus.network,
        errorMessage: _netException.message,
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
      loadUpcomingPaymentsUseCase: _loadUpcomingPaymentsUseCase,
      limit: _limit,
    ),
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        errorStatus: UpcomingPaymentErrorStatus.none,
      ),
      _defaultState.copyWith(
        errorStatus: UpcomingPaymentErrorStatus.generic,
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
