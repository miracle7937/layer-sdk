import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

final _repositoryList = <Payment>[];
final _defaultLimit = 10;
final _customerId = '200000';

final _netExceptionId = '1337';
final _genericErrorId = '7331';

late MockPaymentRepository _repository;

PaymentCubit _buildCubit({
  String? customerId,
}) =>
    PaymentCubit(
      customerId: customerId ?? _customerId,
      repository: _repository,
      limit: _defaultLimit,
    );

PaymentState _defaultState = PaymentState(
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
        recurring: false,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
        recurring: false,
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
        recurring: false,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.skip(_defaultLimit * 2).toList(),
    );

    when(
      () => _repository.list(
        customerId: _netExceptionId,
        limit: _defaultLimit,
        offset: 0,
        recurring: false,
      ),
    ).thenThrow(
      NetException(message: 'Some network error'),
    );

    when(
      () => _repository.list(
        customerId: _genericErrorId,
        limit: _defaultLimit,
        offset: 0,
        recurring: false,
      ),
    ).thenThrow(
      Exception('Some generic error'),
    );
  });

  blocTest<PaymentCubit, PaymentState>(
    'starts on empty state',
    build: _buildCubit,
    verify: (c) => expect(c.state, _defaultState),
  ); // starts on empty state

  blocTest<PaymentCubit, PaymentState>(
    'should load payments',
    build: _buildCubit,
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(busy: true),
      _defaultState.copyWith(
        payments: _repositoryList.take(_defaultLimit).toList(),
        canLoadMore: true,
      ),
    ],
    verify: (c) {
      verify(() =>
              _repository.list(customerId: _customerId, limit: _defaultLimit))
          .called(1);
    },
  ); // should load payments

  blocTest<PaymentCubit, PaymentState>(
    'should load more payments',
    build: _buildCubit,
    seed: () => _defaultState.copyWith(
      payments: _repositoryList.take(_defaultLimit).toList(),
      canLoadMore: true,
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        payments: _repositoryList.take(_defaultLimit).toList(),
        canLoadMore: true,
      ),
      _defaultState.copyWith(
        payments: _repositoryList.take(_defaultLimit * 2).toList(),
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            customerId: _customerId,
            limit: _defaultLimit,
            offset: _defaultLimit,
          )).called(1);
    },
  ); // should load more payments

  blocTest<PaymentCubit, PaymentState>(
    'should return load more = false on list end',
    build: _buildCubit,
    seed: () => _defaultState.copyWith(
      payments: _repositoryList.take(_defaultLimit * 2).toList(),
      canLoadMore: true,
      offset: _defaultLimit,
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        payments: _repositoryList.take(_defaultLimit * 2).toList(),
        canLoadMore: true,
        offset: _defaultLimit,
      ),
      _defaultState.copyWith(
        payments: _repositoryList,
        canLoadMore: false,
        offset: _defaultLimit * 2,
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            customerId: _customerId,
            limit: _defaultLimit,
            offset: _defaultLimit * 2,
          )).called(1);
    },
  ); // should return load more = false on list end

  blocTest<PaymentCubit, PaymentState>(
    'should handle net exception',
    build: () => _buildCubit(customerId: _netExceptionId),
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _netExceptionId,
      ),
      _defaultState.copyWith(
        canLoadMore: true,
        customerId: _netExceptionId,
        errorStatus: PaymentErrorStatus.network,
        busy: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _netExceptionId,
          limit: _defaultLimit,
        ),
      ).called(1);
    },
    errors: () => [
      isA<NetException>(),
    ],
  );

  blocTest<PaymentCubit, PaymentState>(
    'should handle generic exception',
    build: () => _buildCubit(customerId: _genericErrorId),
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        customerId: _genericErrorId,
      ),
      _defaultState.copyWith(
        canLoadMore: true,
        customerId: _genericErrorId,
        errorStatus: PaymentErrorStatus.generic,
        busy: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _genericErrorId,
          limit: _defaultLimit,
        ),
      ).called(1);
    },
    errors: () => [
      isA<Exception>(),
    ],
  );
}
