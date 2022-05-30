import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBillRepository extends Mock implements BillRepository {}

late MockBillRepository _repo;

final _defaultLimit = 10;
final _customerId = '200000';

final _netExceptionId = '1337';
final _genericExceptionId = '7331';

void main() {
  EquatableConfig.stringify = true;

  final _mockedBills = List.generate(
    20,
    (index) => Bill(
      billID: index,
      nickname: 'Bill $index',
      service: Service(
        serviceId: index,
        billerId: index.toString(),
        name: 'Service $index',
        created: DateTime.now(),
      ),
      billStatus: BillStatus.active,
      billingNumber: index.toString(),
      created: DateTime.now(),
    ),
  );

  setUpAll(() {
    _repo = MockBillRepository();

    /// Test case that retrieves all mocked
    /// bills between the default limit
    when(
      () => _repo.list(
        customerId: _customerId,
        limit: _defaultLimit,
        offset: 0,
      ),
    ).thenAnswer((_) async => _mockedBills.take(_defaultLimit).toList());

    /// Test case that retrieves a portion of mocked
    /// bills between the default limit
    when(
      () => _repo.list(
        limit: _defaultLimit,
        offset: _defaultLimit,
        customerId: _customerId,
      ),
    ).thenAnswer(
      (_) async =>
          _mockedBills.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    /// Test case that retrieves a portion of mocked
    /// transactions between the default limit
    when(
      () => _repo.list(
        limit: _defaultLimit,
        offset: _defaultLimit * 2,
        customerId: _customerId,
      ),
    ).thenAnswer(
      (_) async => _mockedBills.skip(_defaultLimit * 2).toList(),
    );

    when(
      () => _repo.list(
        customerId: _netExceptionId,
        limit: any(named: 'limit'),
        forceRefresh: any(named: 'forceRefresh'),
        offset: any(named: 'offset'),
      ),
    ).thenThrow(
      NetException(message: 'Some network error'),
    );

    when(
      () => _repo.list(
        customerId: _genericExceptionId,
        limit: any(named: 'limit'),
        forceRefresh: any(named: 'forceRefresh'),
        offset: any(named: 'offset'),
      ),
    ).thenThrow(
      Exception('Some generic error'),
    );
  });

  blocTest<BillCubit, BillState>(
    'Starts with empty state',
    build: () => BillCubit(
      customerId: _customerId,
      repository: _repo,
    ),
    verify: (c) => expect(
      c.state,
      BillState(
        customerId: _customerId,
      ),
    ),
  );

  blocTest<BillCubit, BillState>(
    'Load bills',
    build: () => BillCubit(
      customerId: _customerId,
      repository: _repo,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    expect: () => [
      BillState(
        busy: true,
        customerId: _customerId,
      ),
      BillState(
        customerId: _customerId,
        busy: false,
        bills: _mockedBills.take(_defaultLimit).toList(),
        errorStatus: BillsErrorStatus.none,
      ),
    ],
  );

  blocTest<BillCubit, BillState>(
    'Loads next page of bills',
    build: () => BillCubit(
      customerId: _customerId,
      repository: _repo,
      limit: _defaultLimit,
    ),
    seed: () => BillState(
      bills: _mockedBills.take(_defaultLimit).toList(),
      customerId: _customerId,
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      BillState(
        busy: true,
        customerId: _customerId,
        bills: _mockedBills.take(_defaultLimit).toList(),
      ),
      BillState(
        customerId: _customerId,
        bills: _mockedBills.take(_defaultLimit * 2).toList(),
      ),
    ],
    verify: (c) {
      verify(() => _repo.list(
            customerId: _customerId,
            limit: _defaultLimit,
            offset: _defaultLimit,
          )).called(1);
    },
  );

  blocTest<BillCubit, BillState>(
    'Sets canLoadMore == false when no more items to load',
    build: () => BillCubit(
      customerId: _customerId,
      repository: _repo,
      limit: _defaultLimit,
    ),
    seed: () => BillState(
      bills: _mockedBills.take(_defaultLimit * 2).toList(),
      customerId: _customerId,
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      BillState(
        busy: true,
        canLoadMore: true,
        customerId: _customerId,
        bills: _mockedBills.take(_defaultLimit * 2).toList(),
      ),
      BillState(
        customerId: _customerId,
        canLoadMore: false,
        bills: _mockedBills,
      ),
    ],
    verify: (c) {
      verifyNever(
        () => _repo.list(
          customerId: _customerId,
          limit: _defaultLimit,
          offset: _defaultLimit * 2,
        ),
      );
    },
  );

  blocTest<BillCubit, BillState>(
    'Should handle network exceptions',
    build: () => BillCubit(
      customerId: _netExceptionId,
      repository: _repo,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    expect: () => [
      BillState(
        busy: true,
        customerId: _netExceptionId,
      ),
      BillState(
        customerId: _netExceptionId,
        busy: false,
        errorStatus: BillsErrorStatus.network,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
  );

  blocTest<BillCubit, BillState>(
    'Should handle generic exceptions',
    build: () => BillCubit(
      customerId: _genericExceptionId,
      repository: _repo,
      limit: _defaultLimit,
    ),
    act: (c) => c.load(),
    expect: () => [
      BillState(
        busy: true,
        customerId: _genericExceptionId,
      ),
      BillState(
        customerId: _genericExceptionId,
        busy: false,
        errorStatus: BillsErrorStatus.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
  );
}
