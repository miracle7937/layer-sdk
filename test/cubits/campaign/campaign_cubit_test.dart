import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models/campaign/campaign_response.dart';
import 'package:layer_sdk/domain_layer/models/campaign/customer_campaign.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits/campaign/campaign_cubit.dart';
import 'package:layer_sdk/presentation_layer/cubits/campaign/campaign_state.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCampaignRepository extends Mock
    implements CampaignRepositoryInterface {}

final _repository = MockCampaignRepository();
final _loadCampaigns = LoadCampaignsUseCase(repository: _repository);

final _limit = 5;

final _successCamapignTypes = [CampaignType.popup];
final _publicCamapignTargets = CampaignTarget.public;
final _failureCampaignType = [CampaignType.unknown];

final _netException = NetException(message: 'Server timed out');
final _genericException = Exception();

final _mockedCampaigns = List.generate(
  8,
  (index) => CustomerCampaign(
    id: index,
    description: 'Campaign $index',
    actionMessage: 'act $index',
    actionValue: 'val $index',
    html: 'html $index',
    imageUrl: 'image $index',
    message: 'mes $index',
    messageType: 'mType $index',
    referenceImage: 'ref $index',
    thumbnailUrl: 'thumb $index',
    title: 'title $index',
    updatedAt: 'update $index',
    videoUrl: 'vid $index',
    medium: CampaignType.popup,
    action: CampaignActionType.callOrSend,
  ),
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      () => _repository.list(
        types: _successCamapignTypes,
        offset: 0,
        limit: _limit,
        target: _publicCamapignTargets,
        desc: any(named: 'desc'),
        read: any(named: 'read'),
        sortby: any(named: 'sortby'),
      ),
    ).thenAnswer(
      (_) async => CampaignResponse(
        totalCount: _mockedCampaigns.length,
        campaigns: _mockedCampaigns.take(_limit),
      ),
    );

    when(
      () => _repository.list(
        offset: _limit,
        limit: _limit,
        types: _successCamapignTypes,
        target: _publicCamapignTargets,
        read: any(named: 'read'),
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenAnswer(
      (_) async => CampaignResponse(
        totalCount: _mockedCampaigns.length,
        campaigns: _mockedCampaigns.skip(_limit).take(_limit),
      ),
    );

    when(
      () => _repository.list(
        types: _failureCampaignType,
        offset: 0,
        limit: _limit,
        target: _publicCamapignTargets,
        read: any(named: 'read'),
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenThrow(_netException);

    when(
      () => _repository.list(
        types: _failureCampaignType,
        offset: _limit,
        limit: _limit,
        target: _publicCamapignTargets,
        read: any(named: 'read'),
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenThrow(_genericException);

    when(
      () => _repository.list(
        offset: 0,
        limit: _limit,
        target: _publicCamapignTargets,
        read: any(named: 'read'),
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenAnswer(
      (_) async => CampaignResponse(
        totalCount: _mockedCampaigns.length,
        campaigns: _mockedCampaigns.take(1),
      ),
    );
  });

  group(
    'CampaignCubit for All',
    () => _testType(
      _loadCampaigns,
    ),
  );
}

void _testType(LoadCampaignsUseCase userCase) {
  final defaultPagination = Pagination(limit: _limit);

  final defaultState = CampaignState(
    pagination: Pagination(limit: _limit),
  );

  blocTest<CampaignCubit, CampaignState>(
    'starts on empty state',
    build: () => CampaignCubit(
      loadCampaigns: userCase,
      limit: _limit,
    ),
    verify: (c) => expect(
      c.state,
      defaultState,
    ),
  ); // starts on empty state
  blocTest<CampaignCubit, CampaignState>(
    'should load Campaigns',
    build: () => CampaignCubit(
      loadCampaigns: userCase,
      limit: _limit,
    ),
    act: (c) => c.load(types: [CampaignType.popup]),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        campaigns: _mockedCampaigns.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          types: _successCamapignTypes,
          offset: 0,
          limit: _limit,
          target: _publicCamapignTargets,
          desc: any(named: 'desc'),
          read: any(named: 'read'),
          sortby: any(named: 'sortby'),
        ),
      ).called(1);
    },
  ); // should load Campaigns

  blocTest<CampaignCubit, CampaignState>(
    'should load more Campaigns',
    build: () => CampaignCubit(
      loadCampaigns: userCase,
      limit: _limit,
    ),
    act: (c) => c.load(loadMore: true, types: [CampaignType.popup]),
    seed: () => defaultState.copyWith(
      campaigns: _mockedCampaigns.take(_limit).toList(),
      pagination: defaultPagination.copyWith(canLoadMore: true),
    ),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        campaigns: _mockedCampaigns.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
      defaultState.copyWith(
        campaigns: _mockedCampaigns.take(_limit * 2).toList(),
        pagination: defaultPagination.copyWith(
          offset: _limit,
          canLoadMore: false,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          types: _successCamapignTypes,
          offset: _limit,
          limit: _limit,
          target: _publicCamapignTargets,
          desc: any(named: 'desc'),
          read: any(named: 'read'),
          sortby: any(named: 'sortby'),
        ),
      ).called(1);
    },
  ); // should load more Campaigns
  blocTest<CampaignCubit, CampaignState>(
    'should load using all parameters',
    build: () => CampaignCubit(
      loadCampaigns: userCase,
      limit: _limit,
    ),
    act: (c) => c.load(
      types: _successCamapignTypes,
      read: true,
      sortby: "ts_created",
      desc: true,
    ),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        campaigns: _mockedCampaigns.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          types: _successCamapignTypes,
          offset: 0,
          limit: _limit,
          target: _publicCamapignTargets,
          desc: any(named: 'desc'),
          read: any(named: 'read'),
          sortby: any(named: 'sortby'),
        ),
      ).called(1);
    },
  ); // should load using all parameters

  blocTest<CampaignCubit, CampaignState>(
    'should handle NetException',
    build: () => CampaignCubit(
      loadCampaigns: userCase,
      limit: _limit,
    ),
    act: (c) => c.load(types: _failureCampaignType),
    expect: () => [
      defaultState.copyWith(
        busy: true,
      ),
      defaultState.copyWith(
        error: CampaignStateError.network,
        errorMessage: _netException.message,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          types: _failureCampaignType,
          offset: 0,
          limit: _limit,
        ),
      ).called(1);
    },
  ); // should handle NetException

  blocTest<CampaignCubit, CampaignState>(
    'should handle generic exceptions',
    build: () => CampaignCubit(
      loadCampaigns: userCase,
      limit: _limit,
    ),
    seed: () => defaultState.copyWith(
      campaigns: _mockedCampaigns.take(_limit).toList(),
      pagination: defaultPagination.copyWith(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true, types: _failureCampaignType),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        campaigns: _mockedCampaigns.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
      defaultState.copyWith(
        campaigns: _mockedCampaigns.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
        error: CampaignStateError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          types: _failureCampaignType,
          offset: _limit,
          limit: _limit,
        ),
      ).called(1);
    },
  ); // should handle generic exceptions
}
