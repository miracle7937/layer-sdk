import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockStandingOrderRepository extends Mock
    implements StandingOrderRepository {}

final _repositoryList = <StandingOrder>[];
final _defaultLimit = 10;
final _customerId = '200001';

late MockStandingOrderRepository _repository;
late StandingOrdersCubit _cubit;

final _defaultState = StandingOrdersState(
  customerId: _customerId,
  pagination: Pagination(limit: _defaultLimit),
);

void main() {
  EquatableConfig.stringify = true;

  final random = Random();

  for (var i = 0; i < 20; ++i) {
    _repositoryList.add(
      StandingOrder(
        id: i,
        created: DateTime.now(),
        fromMobile: '',
        toMobile: '',
        currency: 'BHD',
        amount: random.nextDouble() * 10.0,
        status: StandingOrderStatus.completed,
        type: StandingOrderType.own,
      ),
    );
  }

  setUpAll(() {
    _repository = MockStandingOrderRepository();

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => _repositoryList.take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
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
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => _repositoryList.skip(_defaultLimit * 2).toList(),
    );
  });

  setUp(() {
    _cubit = StandingOrdersCubit(
      customerId: _customerId,
      repository: _repository,
      limit: _defaultLimit,
    );
  });

  group('Base tests', _baseTests);
  group('Include details', _includeDetails);
  group('Force refresh', _forceRefresh);
  group('Exceptions', _exceptions);
}

void _baseTests() {
  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'starts on empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      _defaultState,
    ),
  ); // starts on empty state

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should load standing orders',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load standing orders

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should load more standing orders',
    build: () => _cubit,
    seed: () => _defaultState.copyWith(
      orders: _repositoryList.take(_defaultLimit).toList(),
      pagination: _defaultState.pagination.copyWith(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit * 2).toList(),
        pagination: _defaultState.pagination.copyWith(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load more standing orders

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should return load more = false on list end',
    build: () => _cubit,
    seed: () => _defaultState.copyWith(
      orders: _repositoryList.take(_defaultLimit * 2).toList(),
      pagination: _defaultState.pagination.copyWith(
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        orders: _repositoryList.take(_defaultLimit * 2).toList(),
        pagination: _defaultState.pagination.copyWith(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
      _defaultState.copyWith(
        orders: _repositoryList,
        pagination: _defaultState.pagination.copyWith(
          canLoadMore: false,
          offset: _defaultLimit * 2,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit * 2,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should return load more = false on list end
}

void _includeDetails() {
  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should load standing orders with details',
    build: () => _cubit,
    act: (c) => c.load(includeDetails: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load standing orders with details

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should load standing orders without details',
    build: () => _cubit,
    act: (c) => c.load(includeDetails: false),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load standing orders without details
}

void _forceRefresh() {
  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should force load standing orders',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          forceRefresh: true,
        ),
      ).called(1);
    },
  ); // should force load standing orders

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should not force load standing orders',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: false),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should not force load standing orders
}

void _exceptions() {
  setUp(() {
    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(
      NetException(message: 'Net error'),
    );

    when(
      () => _repository.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(
      Exception('Generic error'),
    );
  });

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should handle net exceptions',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        error: StandingOrdersError.network,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle net exceptions

  blocTest<StandingOrdersCubit, StandingOrdersState>(
    'should handle generic errors',
    build: () => _cubit,
    seed: () => _defaultState.copyWith(
      orders: _repositoryList.take(_defaultLimit).toList(),
      pagination: _defaultState.pagination.copyWith(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
      _defaultState.copyWith(
        orders: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
        error: StandingOrdersError.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit,
          includeDetails: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle generic errors
}
