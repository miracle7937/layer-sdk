import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
import 'package:layer_sdk/features/transfer.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadTransfersUseCase extends Mock implements LoadTransfersUseCase {}

class MockGenerateDeviceUIDUseCase extends Mock
    implements GenerateDeviceUIDUseCase {}

final _repositoryList = <Transfer>[];

final _deviceUID = 'LApoWgWWw5hYSoGS0N9R3JKMjVxEMK';
final _defaultLimit = 10;
final _customerId = '200000';

late MockGenerateDeviceUIDUseCase _generateDeviceUIDUseCase;
late MockLoadTransfersUseCase _loadTransfersUseCase;
late TransferCubit _cubit;

final _defaultState = TransferState(
  customerId: _customerId,
  deviceUID: _deviceUID,
  pagination: Pagination(limit: _defaultLimit),
);

void main() {
  EquatableConfig.stringify = true;

  final random = Random();

  for (var i = 0; i < 20; ++i) {
    _repositoryList.add(
      Transfer(
        id: i,
        created: DateTime.now(),
        fromMobile: '',
        toMobile: '',
        currency: 'BHD',
        amount: random.nextDouble() * 10.0,
        status: TransferStatus.completed,
        type: TransferType.own,
      ),
    );
  }

  setUp(() {
    _generateDeviceUIDUseCase = MockGenerateDeviceUIDUseCase();
    when(
      () => _generateDeviceUIDUseCase(30),
    ).thenAnswer(
      (_) => _deviceUID,
    );
    _loadTransfersUseCase = MockLoadTransfersUseCase();
    _cubit = TransferCubit(
      customerId: _customerId,
      loadTransfersUseCase: _loadTransfersUseCase,
      limit: _defaultLimit,
      generateDeviceUIDUseCase: _generateDeviceUIDUseCase,
    );

    when(
      () => _loadTransfersUseCase(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
        includeDetails: any(named: 'includeDetails'),
        recurring: any(named: 'recurring'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => _repositoryList.take(_defaultLimit).toList(),
    );

    when(
      () => _loadTransfersUseCase(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
        includeDetails: any(named: 'includeDetails'),
        recurring: any(named: 'recurring'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async =>
          _repositoryList.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    when(
      () => _loadTransfersUseCase(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit * 2,
        includeDetails: any(named: 'includeDetails'),
        recurring: any(named: 'recurring'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => _repositoryList.skip(_defaultLimit * 2).toList(),
    );
  });

  group('Base tests', _baseTests);
  group('Include details', _includeDetails);
  group('Force refresh', _forceRefresh);
  group('Exceptions', _exceptions);
}

void _baseTests() {
  blocTest<TransferCubit, TransferState>(
    'starts on empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      _defaultState,
    ),
  ); // starts on empty state

  blocTest<TransferCubit, TransferState>(
    'should load transfers',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load transfers

  blocTest<TransferCubit, TransferState>(
    'should load more transfers',
    build: () => _cubit,
    seed: () => _defaultState.copyWith(
      transfers: _repositoryList.take(_defaultLimit).toList(),
      pagination: _defaultState.pagination.copyWith(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit * 2).toList(),
        pagination: _defaultState.pagination.copyWith(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load more transfers

  blocTest<TransferCubit, TransferState>(
    'should return load more = false on list end',
    build: () => _cubit,
    seed: () => _defaultState.copyWith(
      transfers: _repositoryList.take(_defaultLimit * 2).toList(),
      pagination: _defaultState.pagination.copyWith(
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        transfers: _repositoryList.take(_defaultLimit * 2).toList(),
        pagination: _defaultState.pagination.copyWith(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
      _defaultState.copyWith(
        transfers: _repositoryList,
        pagination: _defaultState.pagination.copyWith(
          canLoadMore: false,
          offset: _defaultLimit * 2,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit * 2,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should return load more = false on list end
}

void _includeDetails() {
  blocTest<TransferCubit, TransferState>(
    'should load transfers with details',
    build: () => _cubit,
    act: (c) => c.load(includeDetails: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load transfers with details

  blocTest<TransferCubit, TransferState>(
    'should load transfers without details',
    build: () => _cubit,
    act: (c) => c.load(includeDetails: false),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: false,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load transfers without details
}

void _forceRefresh() {
  blocTest<TransferCubit, TransferState>(
    'should force load transfers',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          recurring: false,
          forceRefresh: true,
        ),
      ).called(1);
    },
  ); // should force load transfers

  blocTest<TransferCubit, TransferState>(
    'should not force load transfers',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: false),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should not force load transfers
}

void _exceptions() {
  setUp(() {
    when(
      () => _loadTransfersUseCase(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
        includeDetails: any(named: 'includeDetails'),
        recurring: any(named: 'recurring'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(
      NetException(message: 'Net error'),
    );

    when(
      () => _loadTransfersUseCase(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: _defaultLimit,
        includeDetails: any(named: 'includeDetails'),
        recurring: any(named: 'recurring'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(
      Exception('Generic error'),
    );
  });

  blocTest<TransferCubit, TransferState>(
    'should handle net exceptions',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
      ),
      _defaultState.copyWith(
        errorStatus: TransferErrorStatus.network,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: 0,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle net exceptions

  blocTest<TransferCubit, TransferState>(
    'should handle generic errors',
    build: () => _cubit,
    seed: () => _defaultState.copyWith(
      transfers: _repositoryList.take(_defaultLimit).toList(),
      pagination: _defaultState.pagination.copyWith(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      _defaultState.copyWith(
        busy: true,
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
      ),
      _defaultState.copyWith(
        transfers: _repositoryList.take(_defaultLimit).toList(),
        pagination: _defaultState.pagination.copyWith(canLoadMore: true),
        errorStatus: TransferErrorStatus.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _loadTransfersUseCase(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit,
          includeDetails: true,
          recurring: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle generic errors
}
