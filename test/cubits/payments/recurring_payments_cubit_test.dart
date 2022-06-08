import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/bills.dart';
import 'package:layer_sdk/features/payments.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

final _repositoryList = <Payment>[];
final _defaultLimit = 10;
final _customerId = '200000';

late MockPaymentRepository _repository;

RecurringPaymentCubit _buildCubit() => RecurringPaymentCubit(
      customerId: _customerId,
      loadCustomerPaymentsUseCase: LoadCustomerPaymentsUseCase(
        repository: _repository,
      ),
      limit: _defaultLimit,
    );

RecurringPaymentState _defaultState = RecurringPaymentState(
  customerId: _customerId,
  limit: _defaultLimit,
);

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 19; ++i) {
    _repositoryList.add(
      Payment(
        id: i,
        created: DateTime.now(),
        bill: Bill(billingNumber: '$i'),
        currency: 'BHD',
        amount: 2.0,
        status: PaymentStatus.completed,
      ),
    );
  }

  setUpAll(() {
    _repository = MockPaymentRepository();

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
        recurring: true,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
        recurring: true,
      ),
    ).thenAnswer(
      (_) async =>
          _repositoryList.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit * 2,
        recurring: true,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.skip(_defaultLimit * 2).toList(),
    );
  });

  blocTest<RecurringPaymentCubit, RecurringPaymentState>(
    'starts on empty state',
    build: _buildCubit,
    verify: (c) => expect(c.state, _defaultState),
  ); // starts on empty state

  blocTest<RecurringPaymentCubit, RecurringPaymentState>(
    'should load payments',
    build: _buildCubit,
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(busy: true),
      _defaultState.copyWith(
        recurringPayments: _repositoryList.take(_defaultLimit).toList(),
        canLoadMore: true,
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            customerId: _customerId,
            limit: _defaultLimit,
            recurring: true,
          )).called(1);
    },
  ); // should load payments

  blocTest<RecurringPaymentCubit, RecurringPaymentState>(
    'should load more payments',
    build: _buildCubit,
    seed: () => _defaultState.copyWith(
      recurringPayments: _repositoryList.take(_defaultLimit).toList(),
      canLoadMore: true,
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        recurringPayments: _repositoryList.take(_defaultLimit).toList(),
        canLoadMore: true,
      ),
      _defaultState.copyWith(
        recurringPayments: _repositoryList.take(_defaultLimit * 2).toList(),
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            customerId: _customerId,
            limit: _defaultLimit,
            offset: _defaultLimit,
            recurring: true,
          )).called(1);
    },
  ); // should load more payments

  blocTest<RecurringPaymentCubit, RecurringPaymentState>(
    'should return load more = false on list end',
    build: _buildCubit,
    seed: () => _defaultState.copyWith(
      recurringPayments: _repositoryList.take(_defaultLimit * 2).toList(),
      canLoadMore: true,
      offset: _defaultLimit,
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        recurringPayments: _repositoryList.take(_defaultLimit * 2).toList(),
        canLoadMore: true,
        offset: _defaultLimit,
      ),
      _defaultState.copyWith(
        recurringPayments: _repositoryList,
        canLoadMore: false,
        offset: _defaultLimit * 2,
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            customerId: _customerId,
            limit: _defaultLimit,
            offset: _defaultLimit * 2,
            recurring: true,
          )).called(1);
    },
  ); // should return load more = false on list end
  group('Error handling', () {
    setUp(() {
      when(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          recurring: true,
        ),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });
    blocTest<RecurringPaymentCubit, RecurringPaymentState>(
      'should handle errror on load payments',
      build: _buildCubit,
      act: (c) => c.load(),
      expect: () => [
        _defaultState.copyWith(busy: true),
        _defaultState.copyWith(
          errorStatus: RecurringPaymentErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _repository.list(
              customerId: _customerId,
              limit: _defaultLimit,
              recurring: true,
            )).called(1);
      },
    );
  });
}
