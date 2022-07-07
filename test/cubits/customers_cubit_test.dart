import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

final _dataCreatedDesc = <Customer>[];
final _dataCreatedAsc = <Customer>[];
final _dataIdDesc = <Customer>[];
final _dataIdAsc = <Customer>[];

final _defaultLimit = 10;
final _searchText = '9';
final _customerIdFilter = '31';
final _branchesFilter = {'7'};

late MockCustomerRepository _repository;
late LoadCustomerUseCase _getCustomerUseCase;
late UpdateCustomerGracePeriodUseCase _updateCustomerGracePeriodUseCase;
late UpdateCustomerEStatementUseCase _updateCustomerEStatementUseCase;

late CustomersCubit _customersCubit;

void main() {
  EquatableConfig.stringify = true;

  final now = DateTime.now();

  // Personal customers
  for (var i = 0; i < 23; ++i) {
    _dataCreatedDesc.add(
      Customer(
        id: '${i.isEven ? 5000 - i : i + 30}',
        firstName: 'Name $i',
        status: CustomerStatus.active,
        type: CustomerType.personal,
        managingBranch: '${i < 10 ? 5 : i > 20 ? 7 : 10}',
        created: now.subtract(Duration(days: i)),
      ),
    );
  }

  // Corporate customers
  for (var i = 0; i < 10; ++i) {
    _dataCreatedDesc.add(
      Customer(
        id: 'Corporate $i',
        firstName: 'Company $i',
        status: CustomerStatus.active,
        type: CustomerType.corporate,
        managingBranch: '${i < 10 ? 5 : i > 20 ? 7 : 10}',
        created: now.subtract(Duration(days: i)),
      ),
    );
  }

  _dataCreatedAsc
    ..addAll(_dataCreatedDesc)
    ..sort((a, b) => a.created?.compareTo(b.created ?? now) ?? 0);

  _dataIdDesc
    ..addAll(_dataCreatedDesc)
    ..sort((a, b) => b.id.compareTo(a.id));

  _dataIdAsc
    ..addAll(_dataCreatedDesc)
    ..sort((a, b) => a.id.compareTo(b.id));

  setUp(() {
    _repository = MockCustomerRepository();
    _getCustomerUseCase = LoadCustomerUseCase(repository: _repository);
    _updateCustomerGracePeriodUseCase =
        UpdateCustomerGracePeriodUseCase(repository: _repository);
    _updateCustomerEStatementUseCase =
        UpdateCustomerEStatementUseCase(repository: _repository);
    _customersCubit = CustomersCubit(
      getCustomerUseCase: _getCustomerUseCase,
      updateCustomerGracePeriodUseCase: _updateCustomerGracePeriodUseCase,
      updateCustomerEStatmentUseCase: _updateCustomerEStatementUseCase,
      limit: _defaultLimit,
    );

    _setupRepository(
      data: _dataCreatedDesc,
      sortBy: CustomerSort.registered,
      descendingOrder: true,
    );

    _setupRepository(
      data: _dataCreatedAsc,
      sortBy: CustomerSort.registered,
      descendingOrder: false,
    );

    _setupRepository(
      data: _dataIdDesc,
      sortBy: CustomerSort.id,
      descendingOrder: true,
    );

    _setupRepository(
      data: _dataIdAsc,
      sortBy: CustomerSort.id,
      descendingOrder: false,
    );
  });

  blocTest<CustomersCubit, CustomersState>(
    'starts on empty state',
    build: () => CustomersCubit(
      getCustomerUseCase: _getCustomerUseCase,
      updateCustomerGracePeriodUseCase: _updateCustomerGracePeriodUseCase,
      updateCustomerEStatmentUseCase: _updateCustomerEStatementUseCase,
      limit: _defaultLimit,
    ),
    verify: (c) => expect(c.state, CustomersState()),
  ); // starts on empty state

  blocTest<CustomersCubit, CustomersState>(
    'resets cubit to an empty state',
    build: () => CustomersCubit(
        getCustomerUseCase: _getCustomerUseCase,
        updateCustomerGracePeriodUseCase: _updateCustomerGracePeriodUseCase,
        updateCustomerEStatmentUseCase: _updateCustomerEStatementUseCase,
        limit: _defaultLimit),
    seed: () => CustomersState(
      customers: _dataCreatedDesc.take(_defaultLimit).toList(),
      listData: CustomerListData(canLoadMore: true),
    ),
    act: (c) => c.reset(),
    expect: () => [
      CustomersState(),
    ],
  ); // starts on empty state

  group('List with default parameters', () {
    blocTest<CustomersCubit, CustomersState>(
      'should list customers',
      build: () => _customersCubit,
      act: (c) => c.load(),
      expect: () => [
        CustomersState(
          actions: {CustomerBusyAction.load},
          listData: CustomerListData(
            sortBy: CustomerSort.registered,
            descendingOrder: true,
          ),
        ),
        CustomersState(
          customers: _dataCreatedDesc.take(_defaultLimit).toList(),
          listData: CustomerListData(
            canLoadMore: true,
            sortBy: CustomerSort.registered,
            descendingOrder: true,
          ),
        ),
      ],
      verify: (c) {
        verify(
          () => _repository.list(
            filters: CustomerFilters(),
            limit: _defaultLimit,
            requestCanceller: _customersCubit.listCanceller,
          ),
        ).called(1);
      },
    ); // should load customers

    blocTest<CustomersCubit, CustomersState>(
      'should list more customers',
      build: () => _customersCubit,
      seed: () => CustomersState(
        customers: _dataCreatedDesc.take(_defaultLimit).toList(),
        listData: CustomerListData(canLoadMore: true),
      ),
      act: (c) => c.load(loadMore: true),
      expect: () => [
        CustomersState(
          actions: {CustomerBusyAction.loadMore},
          customers: _dataCreatedDesc.take(_defaultLimit).toList(),
          listData: CustomerListData(canLoadMore: true),
        ),
        CustomersState(
          customers: _dataCreatedDesc.take(_defaultLimit * 2).toList(),
          listData: CustomerListData(
            canLoadMore: true,
            sortBy: CustomerSort.registered,
            descendingOrder: true,
            offset: _defaultLimit,
          ),
        ),
      ],
      verify: (c) {
        verify(
          () => _repository.list(
            filters: CustomerFilters(),
            limit: _defaultLimit,
            offset: _defaultLimit,
            requestCanceller: _customersCubit.listCanceller,
          ),
        ).called(1);
      },
    ); // should load more customers

    blocTest<CustomersCubit, CustomersState>(
      'should return load more = false on list end',
      build: () => _customersCubit,
      seed: () => CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.personal)
            .take(_defaultLimit * 2)
            .toList(),
        listData: CustomerListData(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
      act: (c) => c.load(loadMore: true),
      expect: () => [
        CustomersState(
          actions: {CustomerBusyAction.loadMore},
          customers: _dataCreatedDesc
              .where((e) => e.type == CustomerType.personal)
              .take(_defaultLimit * 2)
              .toList(),
          listData: CustomerListData(
            canLoadMore: true,
            sortBy: CustomerSort.registered,
            descendingOrder: true,
            offset: _defaultLimit,
          ),
        ),
        CustomersState(
          customers: _dataCreatedDesc.where(
            (e) => e.type == CustomerType.personal,
          ),
          listData: CustomerListData(
            canLoadMore: false,
            sortBy: CustomerSort.registered,
            descendingOrder: true,
            offset: _defaultLimit * 2,
          ),
        ),
      ],
      verify: (c) {
        verify(
          () => _repository.list(
            filters: CustomerFilters(),
            limit: _defaultLimit,
            offset: _defaultLimit * 2,
            requestCanceller: _customersCubit.listCanceller,
          ),
        ).called(1);
      },
    ); // should return load more = false on list end
  });

  group('Filter tests', _filterTests);
  group('Error tests', _testErrors);
  group('Sort tests', _testSort);
  group('Auto reset tests', _testAutoReset);
  group('Corporate tests', _corporate);
}

void _setupRepository({
  required List<Customer> data,
  required CustomerSort sortBy,
  required bool descendingOrder,
}) {
  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: 0,
      filters: any(named: 'filters'),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.personal)
        .take(_defaultLimit)
        .toList(),
  );

  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: 0,
      customerType: CustomerType.corporate,
      filters: any(named: 'filters'),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.corporate)
        .take(_defaultLimit)
        .toList(),
  );

  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: _defaultLimit,
      filters: any(named: 'filters'),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.personal)
        .skip(_defaultLimit)
        .take(_defaultLimit)
        .toList(),
  );

  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: _defaultLimit * 2,
      filters: any(named: 'filters'),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.personal)
        .skip(_defaultLimit * 2)
        .take(_defaultLimit)
        .toList(),
  );

  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: 0,
      filters: CustomerFilters(name: _searchText),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.personal)
        .where((e) => e.firstName.contains(_searchText))
        .take(_defaultLimit)
        .toList(),
  );

  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: 0,
      filters: CustomerFilters(id: _customerIdFilter),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
      id: _customerIdFilter,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.personal)
        .where((e) => e.id == _customerIdFilter)
        .take(_defaultLimit)
        .toList(),
  );

  when(
    () => _repository.list(
      limit: _defaultLimit,
      offset: 0,
      filters: CustomerFilters(branchIds: _branchesFilter),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      requestCanceller: _customersCubit.listCanceller,
    ),
  ).thenAnswer(
    (_) async => data
        .where((e) => e.type == CustomerType.personal)
        .where((e) => _branchesFilter.contains(e.managingBranch))
        .take(_defaultLimit)
        .toList(),
  );
}

void _filterTests() {
  blocTest<CustomersCubit, CustomersState>(
    'should search customers by name',
    build: () => _customersCubit,
    act: (c) => c.load(
      filters: CustomerFilters(name: _searchText),
    ),
    expect: () => [
      CustomersState(actions: {CustomerBusyAction.load}),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.personal)
            .where((e) => e.firstName.contains(_searchText))
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: false,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
          filters: CustomerFilters(name: _searchText),
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          limit: _defaultLimit,
          filters: CustomerFilters(name: _searchText),
          requestCanceller: _customersCubit.listCanceller,
        ),
      ).called(1);
    },
  ); // should search customers by name

  blocTest<CustomersCubit, CustomersState>(
    'should search customers by id',
    build: () => _customersCubit,
    act: (c) => c.load(
      filters: CustomerFilters(id: _customerIdFilter),
    ),
    expect: () => [
      CustomersState(actions: {CustomerBusyAction.load}),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.personal)
            .where((e) => e.id == _customerIdFilter)
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: false,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
          filters: CustomerFilters(id: _customerIdFilter),
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          limit: _defaultLimit,
          filters: CustomerFilters(id: _customerIdFilter),
          requestCanceller: _customersCubit.listCanceller,
          id: _customerIdFilter,
        ),
      ).called(1);
    },
  ); // should search customers by id

  blocTest<CustomersCubit, CustomersState>(
    'should search customers by branch id',
    build: () => _customersCubit,
    act: (c) => c.load(
      filters: CustomerFilters(branchIds: _branchesFilter),
    ),
    expect: () => [
      CustomersState(actions: {CustomerBusyAction.load}),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.personal)
            .where((e) => _branchesFilter.contains(e.managingBranch))
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: false,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
          filters: CustomerFilters(branchIds: _branchesFilter),
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          limit: _defaultLimit,
          filters: CustomerFilters(branchIds: _branchesFilter),
          requestCanceller: _customersCubit.listCanceller,
        ),
      ).called(1);
    },
  ); // should search customers by branch id
}

void _testErrors() {
  setUp(() {
    when(
      () => _repository.list(
        filters: CustomerFilters(),
        limit: _defaultLimit,
        offset: 0,
        descendingOrder: true,
        requestCanceller: _customersCubit.listCanceller,
      ),
    ).thenThrow(Exception());
  });

  blocTest<CustomersCubit, CustomersState>(
    'should throw exception and set error',
    build: () => _customersCubit,
    act: (c) => c.load(),
    expect: () => [
      CustomersState(actions: {CustomerBusyAction.load}),
      CustomersState(
        error: CustomersStateError.generic,
      ),
    ],
    errors: () => [isA<Exception>()],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          limit: _defaultLimit,
          requestCanceller: _customersCubit.listCanceller,
        ),
      ).called(1);
    },
  ); // should throw exception and set error
}

void _testSort() {
  group(
    'Sort by created desc',
    () => _sortByTests(
      data: _dataCreatedDesc
          .where((e) => e.type == CustomerType.personal)
          .toList(),
      sortBy: CustomerSort.registered,
      descendingOrder: true,
    ),
  ); // Sort by created desc

  group(
    'Sort by created asc',
    () => _sortByTests(
      data: _dataCreatedAsc
          .where((e) => e.type == CustomerType.personal)
          .toList(),
      sortBy: CustomerSort.registered,
      descendingOrder: false,
    ),
  ); // Sort by created asc

  group(
    'Sort by id desc',
    () => _sortByTests(
      data: _dataIdDesc.where((e) => e.type == CustomerType.personal).toList(),
      sortBy: CustomerSort.id,
      descendingOrder: true,
    ),
  ); // Sort by id desc

  group(
    'Sort by id asc',
    () => _sortByTests(
      data: _dataIdAsc.where((e) => e.type == CustomerType.personal).toList(),
      sortBy: CustomerSort.id,
      descendingOrder: false,
    ),
  ); // Sort by id asc
}

void _sortByTests({
  required List<Customer> data,
  required CustomerSort sortBy,
  required bool descendingOrder,
}) {
  blocTest<CustomersCubit, CustomersState>(
    'should list customers',
    build: () => _customersCubit,
    act: (c) => c.load(
      sortBy: sortBy,
      descendingOrder: descendingOrder,
    ),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.load},
        listData: CustomerListData(),
      ),
      CustomersState(
        customers: data.take(_defaultLimit).toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          limit: _defaultLimit,
          requestCanceller: _customersCubit.listCanceller,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
        ),
      ).called(1);
    },
  ); // should load customers

  blocTest<CustomersCubit, CustomersState>(
    'should list more customers',
    build: () => _customersCubit,
    seed: () => CustomersState(
      customers: data.take(_defaultLimit).toList(),
      listData: CustomerListData(
        canLoadMore: true,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
      ),
    ),
    act: (c) => c.load(
      loadMore: true,
      sortBy: sortBy,
      descendingOrder: descendingOrder,
    ),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.loadMore},
        customers: data.take(_defaultLimit).toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
        ),
      ),
      CustomersState(
        customers: data.take(_defaultLimit * 2).toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
          offset: _defaultLimit,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          limit: _defaultLimit,
          offset: _defaultLimit,
          requestCanceller: _customersCubit.listCanceller,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
        ),
      ).called(1);
    },
  ); // should load more customers

  blocTest<CustomersCubit, CustomersState>(
    'should return load more = false on list end',
    build: () => _customersCubit,
    seed: () => CustomersState(
      customers: data.take(_defaultLimit * 2).toList(),
      listData: CustomerListData(
        canLoadMore: true,
        offset: _defaultLimit,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
      ),
    ),
    act: (c) => c.load(
      loadMore: true,
      sortBy: sortBy,
      descendingOrder: descendingOrder,
    ),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.loadMore},
        customers: data.take(_defaultLimit * 2).toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
          offset: _defaultLimit,
        ),
      ),
      CustomersState(
        customers: data,
        listData: CustomerListData(
          canLoadMore: false,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
          offset: _defaultLimit * 2,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          limit: _defaultLimit,
          offset: _defaultLimit * 2,
          requestCanceller: _customersCubit.listCanceller,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
        ),
      ).called(1);
    },
  ); // should return load more = false on list end

  blocTest<CustomersCubit, CustomersState>(
    'should search customers',
    build: () => _customersCubit,
    act: (c) => c.load(
      filters: CustomerFilters(name: _searchText),
      sortBy: sortBy,
      descendingOrder: descendingOrder,
    ),
    expect: () => [
      CustomersState(actions: {CustomerBusyAction.load}),
      CustomersState(
        customers: data
            .where((e) => e.firstName.contains(_searchText))
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: false,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
          filters: CustomerFilters(name: _searchText),
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          limit: _defaultLimit,
          filters: CustomerFilters(name: _searchText),
          requestCanceller: _customersCubit.listCanceller,
          sortBy: sortBy,
          descendingOrder: descendingOrder,
        ),
      ).called(1);
    },
  ); // should search customers
}

void _testAutoReset() {
  blocTest<CustomersCubit, CustomersState>(
    'should reset list if sort changes',
    build: () => _customersCubit,
    seed: () => CustomersState(
      customers: _dataIdDesc
          .where((e) => e.type == CustomerType.personal)
          .take(_defaultLimit * 2)
          .toList(),
      listData: CustomerListData(
        canLoadMore: true,
        sortBy: CustomerSort.id,
        descendingOrder: false,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(
      loadMore: true,
      sortBy: CustomerSort.registered,
      descendingOrder: true,
    ),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.load},
        customers: _dataIdDesc
            .where((e) => e.type == CustomerType.personal)
            .take(_defaultLimit * 2)
            .toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: CustomerSort.id,
          descendingOrder: false,
          offset: _defaultLimit,
        ),
      ),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.personal)
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          limit: _defaultLimit,
          offset: 0,
          requestCanceller: _customersCubit.listCanceller,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
        ),
      ).called(1);
    },
  ); // should reset list if sort changes

  blocTest<CustomersCubit, CustomersState>(
    'should reset list if filtering changes',
    build: () => _customersCubit,
    seed: () => CustomersState(
      customers: _dataIdDesc
          .where((e) => e.type == CustomerType.personal)
          .take(_defaultLimit * 2)
          .toList(),
      listData: CustomerListData(
        canLoadMore: true,
        sortBy: CustomerSort.id,
        descendingOrder: false,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(
      loadMore: true,
      filters: CustomerFilters(id: _customerIdFilter),
      sortBy: CustomerSort.id,
      descendingOrder: false,
    ),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.load},
        customers: _dataIdDesc
            .where((e) => e.type == CustomerType.personal)
            .take(_defaultLimit * 2)
            .toList(),
        listData: CustomerListData(
          canLoadMore: true,
          sortBy: CustomerSort.id,
          descendingOrder: false,
          offset: _defaultLimit,
        ),
      ),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.personal)
            .where((e) => e.id == _customerIdFilter)
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: false,
          filters: CustomerFilters(id: _customerIdFilter),
          sortBy: CustomerSort.id,
          descendingOrder: false,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          limit: _defaultLimit,
          offset: 0,
          filters: CustomerFilters(id: _customerIdFilter),
          requestCanceller: _customersCubit.listCanceller,
          sortBy: CustomerSort.id,
          descendingOrder: false,
          id: _customerIdFilter,
        ),
      ).called(1);
    },
  ); // should reset list if filtering changes

  blocTest<CustomersCubit, CustomersState>(
    'should reset list if customer type changes',
    build: () => _customersCubit,
    seed: () => CustomersState(
      customers: _dataIdDesc
          .where((e) => e.type == CustomerType.personal)
          .take(_defaultLimit * 2)
          .toList(),
      listData: CustomerListData(
        customerType: CustomerType.personal,
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(
      loadMore: true,
      customerType: CustomerType.corporate,
      descendingOrder: true,
    ),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.load},
        customers: _dataIdDesc
            .where((e) => e.type == CustomerType.personal)
            .take(_defaultLimit * 2)
            .toList(),
        listData: CustomerListData(
          canLoadMore: true,
          customerType: CustomerType.corporate,
          descendingOrder: true,
          offset: _defaultLimit,
        ),
      ),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.corporate)
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          canLoadMore: true,
          customerType: CustomerType.corporate,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          limit: _defaultLimit,
          offset: 0,
          customerType: CustomerType.corporate,
          requestCanceller: _customersCubit.listCanceller,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
        ),
      ).called(1);
    },
  ); // should reset list if customer type changes
}

void _corporate() {
  blocTest<CustomersCubit, CustomersState>(
    'should list corporate customers',
    build: () => _customersCubit,
    act: (c) => c.load(customerType: CustomerType.corporate),
    expect: () => [
      CustomersState(
        actions: {CustomerBusyAction.load},
        listData: CustomerListData(
          customerType: CustomerType.corporate,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
        ),
      ),
      CustomersState(
        customers: _dataCreatedDesc
            .where((e) => e.type == CustomerType.corporate)
            .take(_defaultLimit)
            .toList(),
        listData: CustomerListData(
          customerType: CustomerType.corporate,
          canLoadMore: true,
          sortBy: CustomerSort.registered,
          descendingOrder: true,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          filters: CustomerFilters(),
          customerType: CustomerType.corporate,
          limit: _defaultLimit,
          requestCanceller: _customersCubit.listCanceller,
        ),
      ).called(1);
    },
  ); // should list corporate customers
}
