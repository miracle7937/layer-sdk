import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBeneficiaryRepository extends Mock implements BeneficiaryRepository {}

final _repositoryList = <Beneficiary>[];
final _defaultLimit = 10;
final _searchText = '9';
final _customerID = '200000';

final _netExceptionId = '1337';
final _genericErrorId = '7331';

late MockBeneficiaryRepository _repository;

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 23; ++i) {
    _repositoryList.add(
      Beneficiary(
        id: i,
        firstName: 'Name $i',
        middleName: 'MiddleName $i',
        lastName: 'LastName $i',
        accountNumber: (23 + i).toString(),
        bankName: 'Bank $i',
        bankCountryCode: 'BankCountryCode $i',
        status: BeneficiaryStatus.active,
        nickname: '',
      ),
    );
  }

  setUpAll(() {
    _repository = MockBeneficiaryRepository();

    when(
      () => _repository.list(
        limit: _defaultLimit,
        offset: 0,
        searchText: null,
        customerID: _customerID,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        limit: _defaultLimit,
        offset: _defaultLimit,
        searchText: null,
        customerID: _customerID,
      ),
    ).thenAnswer(
      (_) async =>
          _repositoryList.skip(_defaultLimit).take(_defaultLimit).toList(),
    );

    when(
      () => _repository.list(
        limit: _defaultLimit,
        offset: _defaultLimit * 2,
        searchText: null,
        customerID: _customerID,
      ),
    ).thenAnswer(
      (_) async => _repositoryList.skip(_defaultLimit * 2).toList(),
    );

    when(
      () => _repository.list(
        limit: _defaultLimit,
        offset: 0,
        searchText: _searchText,
        customerID: _customerID,
      ),
    ).thenAnswer(
      (_) async => _repositoryList
          .where((e) => e.firstName.contains(_searchText))
          .take(_defaultLimit)
          .toList(),
    );

    when(
      () => _repository.list(
        limit: _defaultLimit,
        offset: any(named: 'offset'),
        searchText: any(named: 'searchText'),
        customerID: _netExceptionId,
      ),
    ).thenThrow(
      NetException(message: 'Some network error'),
    );

    when(
      () => _repository.list(
        limit: _defaultLimit,
        offset: any(named: 'offset'),
        searchText: any(named: 'searchText'),
        customerID: _genericErrorId,
      ),
    ).thenThrow(
      Exception('Some generic error'),
    );
  });

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'starts on empty state',
    build: () => BeneficiariesCubit(
      repository: _repository,
      customerID: _customerID,
    ),
    verify: (c) => expect(
        c.state,
        BeneficiariesState(
          customerID: _customerID,
        )),
  ); // starts on empty state

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'should load beneficiaries',
    build: () => BeneficiariesCubit(
      repository: _repository,
      limit: _defaultLimit,
      customerID: _customerID,
    ),
    act: (c) => c.load(),
    expect: () => [
      BeneficiariesState(
        busy: true,
        customerID: _customerID,
        errorStatus: BeneficiariesErrorStatus.none,
      ),
      BeneficiariesState(
        customerID: _customerID,
        beneficiaries: _repositoryList.take(_defaultLimit).toList(),
        errorStatus: BeneficiariesErrorStatus.none,
        listData: BeneficiaryListData(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            limit: _defaultLimit,
            customerID: _customerID,
          )).called(1);
    },
  );

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'should load more beneficiaries',
    build: () => BeneficiariesCubit(
      repository: _repository,
      limit: _defaultLimit,
      customerID: _customerID,
    ),
    seed: () => BeneficiariesState(
      customerID: _customerID,
      beneficiaries: _repositoryList.take(_defaultLimit).toList(),
      listData: BeneficiaryListData(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      BeneficiariesState(
        customerID: _customerID,
        busy: true,
        errorStatus: BeneficiariesErrorStatus.none,
        beneficiaries: _repositoryList.take(_defaultLimit).toList(),
        listData: BeneficiaryListData(canLoadMore: true),
      ),
      BeneficiariesState(
        customerID: _customerID,
        errorStatus: BeneficiariesErrorStatus.none,
        beneficiaries: _repositoryList.take(_defaultLimit * 2).toList(),
        listData: BeneficiaryListData(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            limit: _defaultLimit,
            offset: _defaultLimit,
            customerID: _customerID,
          )).called(1);
    },
  ); // should load more beneficiaries

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'should return load more = false on list end',
    build: () => BeneficiariesCubit(
      repository: _repository,
      limit: _defaultLimit,
      customerID: _customerID,
    ),
    seed: () => BeneficiariesState(
      customerID: _customerID,
      beneficiaries: _repositoryList.take(_defaultLimit * 2).toList(),
      listData: BeneficiaryListData(
        canLoadMore: true,
        offset: _defaultLimit,
      ),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      BeneficiariesState(
        customerID: _customerID,
        errorStatus: BeneficiariesErrorStatus.none,
        busy: true,
        beneficiaries: _repositoryList.take(_defaultLimit * 2).toList(),
        listData: BeneficiaryListData(
          canLoadMore: true,
          offset: _defaultLimit,
        ),
      ),
      BeneficiariesState(
        customerID: _customerID,
        beneficiaries: _repositoryList,
        errorStatus: BeneficiariesErrorStatus.none,
        listData: BeneficiaryListData(
          canLoadMore: false,
          offset: _defaultLimit * 2,
        ),
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            limit: _defaultLimit,
            offset: _defaultLimit * 2,
            customerID: _customerID,
          )).called(1);
    },
  ); // should return load more = false on list end

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'should search beneficiaries',
    build: () => BeneficiariesCubit(
      repository: _repository,
      limit: _defaultLimit,
      customerID: _customerID,
    ),
    act: (c) => c.load(searchText: _searchText),
    expect: () => [
      BeneficiariesState(
        busy: true,
        errorStatus: BeneficiariesErrorStatus.none,
        customerID: _customerID,
      ),
      BeneficiariesState(
        customerID: _customerID,
        errorStatus: BeneficiariesErrorStatus.none,
        beneficiaries: _repositoryList
            .where((e) => e.firstName.contains(_searchText))
            .take(_defaultLimit)
            .toList(),
        listData: BeneficiaryListData(
          canLoadMore: false,
          searchText: _searchText,
        ),
      ),
    ],
    verify: (c) {
      verify(() => _repository.list(
            limit: _defaultLimit,
            searchText: _searchText,
            customerID: _customerID,
          )).called(1);
    },
  ); // should search beneficiaries

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'should handle net exceptions',
    build: () => BeneficiariesCubit(
      repository: _repository,
      limit: _defaultLimit,
      customerID: _netExceptionId,
    ),
    act: (c) => c.load(),
    expect: () => [
      BeneficiariesState(
        busy: true,
        customerID: _netExceptionId,
        errorStatus: BeneficiariesErrorStatus.none,
      ),
      BeneficiariesState(
        busy: false,
        customerID: _netExceptionId,
        errorStatus: BeneficiariesErrorStatus.network,
        listData: BeneficiaryListData(),
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(() => _repository.list(
            limit: _defaultLimit,
            customerID: _netExceptionId,
          )).called(1);
    },
  );

  blocTest<BeneficiariesCubit, BeneficiariesState>(
    'should handle generic errors',
    build: () => BeneficiariesCubit(
      repository: _repository,
      limit: _defaultLimit,
      customerID: _genericErrorId,
    ),
    act: (c) => c.load(),
    expect: () => [
      BeneficiariesState(
        busy: true,
        customerID: _genericErrorId,
        errorStatus: BeneficiariesErrorStatus.none,
      ),
      BeneficiariesState(
        busy: false,
        customerID: _genericErrorId,
        errorStatus: BeneficiariesErrorStatus.generic,
        listData: BeneficiaryListData(),
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(() => _repository.list(
            limit: _defaultLimit,
            customerID: _genericErrorId,
          )).called(1);
    },
  );
}
