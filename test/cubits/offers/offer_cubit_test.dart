import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockOfferRepository extends Mock implements OfferRepository {}

final _repository = MockOfferRepository();

final _limit = 5;

final _successRewardType = RewardType.discount;
final _failureRewardType = RewardType.cashback;

final _successIds = [1];
final _genericExceptionIds = [2];
final _netExceptionIds = [3];

final _categories = [1, 17];
final _fromDate = DateTime.now().subtract(const Duration(days: 3));
final _toDate = DateTime.now().subtract(const Duration(days: 1, seconds: 30));
final _latitude = 3.18582;
final _longitude = 1.39282;

final _netException = NetException(message: 'Server timed out');
final _genericException = Exception();

final _mockedOffers = List.generate(
  8,
  (index) => Offer(
    id: index,
    description: 'Offer $index',
    type: OfferType.merchant,
    status: OfferStatus.active,
    merchant: Merchant(),
  ),
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      () => _repository.list(
        rewardType: _successRewardType,
        offset: 0,
        limit: _limit,
        forceRefresh: any(named: 'forceRefresh'),
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenAnswer(
      (_) async => OfferResponse(
        totalCount: _mockedOffers.length,
        offers: _mockedOffers.take(_limit),
      ),
    );

    when(
      () => _repository.list(
        rewardType: _successRewardType,
        offset: _limit,
        limit: _limit,
        forceRefresh: any(named: 'forceRefresh'),
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenAnswer(
      (_) async => OfferResponse(
        totalCount: _mockedOffers.length,
        offers: _mockedOffers.skip(_limit).take(_limit),
      ),
    );

    when(
      () => _repository.list(
        rewardType: _failureRewardType,
        offset: 0,
        limit: _limit,
        forceRefresh: any(named: 'forceRefresh'),
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenThrow(_netException);

    when(
      () => _repository.list(
        rewardType: _failureRewardType,
        offset: _limit,
        limit: _limit,
        forceRefresh: any(named: 'forceRefresh'),
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenThrow(_genericException);

    when(
      () => _repository.list(
        ids: _successIds,
        forceRefresh: any(named: 'forceRefresh'),
        rewardType: _successRewardType,
        offset: 0,
        limit: _limit,
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenAnswer(
      (_) async => OfferResponse(
        totalCount: _successIds.length,
        offers: _mockedOffers.take(1),
      ),
    );

    when(
      () => _repository.list(
        ids: _netExceptionIds,
        rewardType: _failureRewardType,
        offset: 0,
        limit: _limit,
        forceRefresh: any(named: 'forceRefresh'),
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenThrow(_netException);

    when(
      () => _repository.list(
        ids: _genericExceptionIds,
        rewardType: _failureRewardType,
        offset: 0,
        limit: _limit,
        forceRefresh: any(named: 'forceRefresh'),
        from: any(named: 'from'),
        to: any(named: 'to'),
        categories: any(named: 'categories'),
        isFavorites: any(named: 'isFavorites'),
        isForMe: any(named: 'isForMe'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
        latitude: any(named: 'latitude'),
        longitude: any(named: 'longitude'),
      ),
    ).thenThrow(_genericException);
  });

  group('OfferCubit for All', () => _testType(OfferStateType.all));
  group('OfferCubit for Favorite', () => _testType(OfferStateType.favorites));
  group('OfferCubit for For me', () => _testType(OfferStateType.forMe));
  group('Specialized cubits', _specializedCubits);

  group('Get offers by their ids', _offersByTheirIds);
}

void _testType(OfferStateType type) {
  final defaultPagination = Pagination(limit: _limit);

  final defaultState = OfferState(
    type: type,
    rewardType: _successRewardType,
    pagination: Pagination(limit: _limit),
  );

  blocTest<OfferCubit, OfferState>(
    'starts on empty state',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    verify: (c) => expect(
      c.state,
      defaultState,
    ),
  ); // starts on empty state

  blocTest<OfferCubit, OfferState>(
    'should load offers',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    act: (c) => c.load(),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          rewardType: _successRewardType,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
          from: null,
          to: null,
          categories: null,
          isFavorites: type == OfferStateType.favorites,
          isForMe: type == OfferStateType.forMe,
          latitudeForDistance: null,
          longitudeForDistance: null,
          latitude: null,
          longitude: null,
        ),
      ).called(1);
    },
  ); // should load offers

  blocTest<OfferCubit, OfferState>(
    'should force load offers',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          rewardType: _successRewardType,
          offset: 0,
          limit: _limit,
          forceRefresh: true,
          from: null,
          to: null,
          categories: null,
          isFavorites: type == OfferStateType.favorites,
          isForMe: type == OfferStateType.forMe,
          latitudeForDistance: null,
          longitudeForDistance: null,
          latitude: null,
          longitude: null,
        ),
      ).called(1);
    },
  ); // should force load offers

  blocTest<OfferCubit, OfferState>(
    'should load more offers',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    act: (c) => c.load(loadMore: true),
    seed: () => defaultState.copyWith(
      total: _mockedOffers.length,
      offers: _mockedOffers.take(_limit).toList(),
      pagination: defaultPagination.copyWith(canLoadMore: true),
    ),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
      defaultState.copyWith(
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit * 2).toList(),
        pagination: defaultPagination.copyWith(
          offset: _limit,
          canLoadMore: false,
        ),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          rewardType: _successRewardType,
          offset: _limit,
          limit: _limit,
          forceRefresh: false,
          from: null,
          to: null,
          categories: null,
          isFavorites: type == OfferStateType.favorites,
          isForMe: type == OfferStateType.forMe,
          latitudeForDistance: null,
          longitudeForDistance: null,
          latitude: null,
          longitude: null,
        ),
      ).called(1);
    },
  ); // should load more offers

  blocTest<OfferCubit, OfferState>(
    'should load using all parameters',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    act: (c) => c.load(
      categories: _categories,
      fromDate: _fromDate,
      toDate: _toDate,
      latitudeForDistance: _latitude,
      longitudeForDistance: _longitude,
      latitude: _latitude,
      longitude: _longitude,
    ),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          rewardType: _successRewardType,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
          from: _fromDate,
          to: _toDate,
          categories: _categories,
          isFavorites: type == OfferStateType.favorites,
          isForMe: type == OfferStateType.forMe,
          latitudeForDistance: _latitude,
          longitudeForDistance: _longitude,
          latitude: _latitude,
          longitude: _longitude,
        ),
      ).called(1);
    },
  ); // should load using all parameters

  blocTest<OfferCubit, OfferState>(
    'should handle NetException',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _failureRewardType,
    ),
    act: (c) => c.load(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        rewardType: _failureRewardType,
      ),
      defaultState.copyWith(
        error: OfferStateError.network,
        errorMessage: _netException.message,
        rewardType: _failureRewardType,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          rewardType: _failureRewardType,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
          from: null,
          to: null,
          categories: null,
          isFavorites: type == OfferStateType.favorites,
          isForMe: type == OfferStateType.forMe,
          latitudeForDistance: null,
          longitudeForDistance: null,
          latitude: null,
          longitude: null,
        ),
      ).called(1);
    },
  ); // should handle NetException

  blocTest<OfferCubit, OfferState>(
    'should handle generic exceptions',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _failureRewardType,
    ),
    seed: () => defaultState.copyWith(
      rewardType: _failureRewardType,
      total: _mockedOffers.length,
      offers: _mockedOffers.take(_limit).toList(),
      pagination: defaultPagination.copyWith(canLoadMore: true),
    ),
    act: (c) => c.load(loadMore: true),
    expect: () => [
      defaultState.copyWith(
        rewardType: _failureRewardType,
        busy: true,
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
      ),
      defaultState.copyWith(
        rewardType: _failureRewardType,
        total: _mockedOffers.length,
        offers: _mockedOffers.take(_limit).toList(),
        pagination: defaultPagination.copyWith(canLoadMore: true),
        error: OfferStateError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          rewardType: _failureRewardType,
          offset: _limit,
          limit: _limit,
          forceRefresh: false,
          from: null,
          to: null,
          categories: null,
          isFavorites: type == OfferStateType.favorites,
          isForMe: type == OfferStateType.forMe,
          latitudeForDistance: null,
          longitudeForDistance: null,
          latitude: null,
          longitude: null,
        ),
      ).called(1);
    },
  ); // should handle generic exceptions
}

void _specializedCubits() {
  blocTest<AllOffersCubit, OfferState>(
    'AllOffersCubit initializes correctly',
    build: () => AllOffersCubit(
      repository: _repository,
      limit: _limit,
      rewardType: _successRewardType,
    ),
    verify: (c) => expect(
      c.state,
      OfferState(
        type: OfferStateType.all,
        rewardType: _successRewardType,
        pagination: Pagination(limit: _limit),
      ),
    ),
  ); // AllOffersCubit initializes correctly

  blocTest<ForMeOffersCubit, OfferState>(
    'ForMeOffersCubit initializes correctly',
    build: () => ForMeOffersCubit(
      repository: _repository,
      limit: _limit,
      rewardType: _successRewardType,
    ),
    verify: (c) => expect(
      c.state,
      OfferState(
        type: OfferStateType.forMe,
        rewardType: _successRewardType,
        pagination: Pagination(limit: _limit),
      ),
    ),
  ); // ForMeOffersCubit initializes correctly

  blocTest<FavoriteOffersCubit, OfferState>(
    'FavoriteOffersCubit initializes correctly',
    build: () => FavoriteOffersCubit(
      repository: _repository,
      limit: _limit,
      rewardType: _successRewardType,
    ),
    verify: (c) => expect(
      c.state,
      OfferState(
        type: OfferStateType.favorites,
        rewardType: _successRewardType,
        pagination: Pagination(limit: _limit),
      ),
    ),
  ); // FavoriteOffersCubit initializes correctly
}

void _offersByTheirIds() {
  final type = OfferStateType.all;

  final defaultState = OfferState(
    type: type,
    rewardType: _successRewardType,
    pagination: Pagination(limit: _limit),
  );

  blocTest<OfferCubit, OfferState>(
    'starts on empty state',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    verify: (c) => expect(
      c.state,
      defaultState,
    ),
  ); // starts on empty state

  blocTest<OfferCubit, OfferState>(
    'should load offers',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _successRewardType,
    ),
    act: (c) {
      return c.load(ids: _successIds);
    },
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        total: _successIds.length,
        offers: _mockedOffers.take(_successIds.length).toList(),
      ),
    ],
    verify: (c) {
      verify(
        () {
          return _repository.list(
            ids: _successIds,
            rewardType: _successRewardType,
            offset: 0,
            limit: _limit,
            forceRefresh: false,
          );
        },
      ).called(1);
    },
  ); // should load offers

  blocTest<OfferCubit, OfferState>(
    'should handle NetException',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _failureRewardType,
    ),
    act: (c) => c.load(ids: _netExceptionIds),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        rewardType: _failureRewardType,
      ),
      defaultState.copyWith(
        error: OfferStateError.network,
        errorMessage: _netException.message,
        rewardType: _failureRewardType,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          ids: _netExceptionIds,
          rewardType: _failureRewardType,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle NetException

  blocTest<OfferCubit, OfferState>(
    'should handle generic exceptions',
    build: () => OfferCubit(
      repository: _repository,
      limit: _limit,
      offerStateType: type,
      rewardType: _failureRewardType,
    ),
    act: (c) {
      return c.load(ids: _genericExceptionIds);
    },
    expect: () => [
      defaultState.copyWith(
        rewardType: _failureRewardType,
        busy: true,
      ),
      defaultState.copyWith(
        rewardType: _failureRewardType,
        error: OfferStateError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          ids: _genericExceptionIds,
          rewardType: _failureRewardType,
          offset: 0,
          limit: _limit,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle generic exceptions
}
