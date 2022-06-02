import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockOfferRepository extends Mock implements OffersRepositoryInterface {}

final _repository = MockOfferRepository();
final _loadOfferById = LoadOfferByIdUseCase(repository: _repository);

final _successOfferId = 1;
final _netErrorOfferId = 2;
final _genericErrorOfferId = 3;

final _latitude = 3.18582;
final _longitude = 1.39282;

final _netException = NetException(message: 'Server timed out');
final _genericException = Exception();

final _offer = Offer(
  id: _successOfferId,
  description: 'Offer $_successOfferId',
  type: OfferType.merchant,
  status: OfferStatus.active,
  merchant: Merchant(),
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      () => _repository.getOffer(
        id: _successOfferId,
        forceRefresh: any(named: 'forceRefresh'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
      ),
    ).thenAnswer(
      (_) async => _offer,
    );

    when(
      () => _repository.getOffer(
        id: _netErrorOfferId,
        forceRefresh: any(named: 'forceRefresh'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
      ),
    ).thenThrow(_netException);

    when(
      () => _repository.getOffer(
        id: _genericErrorOfferId,
        forceRefresh: any(named: 'forceRefresh'),
        latitudeForDistance: any(named: 'latitudeForDistance'),
        longitudeForDistance: any(named: 'longitudeForDistance'),
      ),
    ).thenThrow(_genericException);
  });

  final defaultState = OfferDetailsState(
    offerId: _successOfferId,
  );

  blocTest<OfferDetailsCubit, OfferDetailsState>(
    'starts on empty state',
    build: () => OfferDetailsCubit(
      loadOfferById: _loadOfferById,
      offerId: _successOfferId,
    ),
    verify: (c) => expect(
      c.state,
      defaultState,
    ),
  ); // starts on empty state

  blocTest<OfferDetailsCubit, OfferDetailsState>(
    'should load an offer',
    build: () => OfferDetailsCubit(
      loadOfferById: _loadOfferById,
      offerId: _successOfferId,
    ),
    act: (c) => c.load(),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        busy: false,
        offer: _offer,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.getOffer(
          id: _successOfferId,
          forceRefresh: false,
          latitudeForDistance: null,
          longitudeForDistance: null,
        ),
      ).called(1);
    },
  ); // should load an offer

  blocTest<OfferDetailsCubit, OfferDetailsState>(
    'should force load an offer',
    build: () => OfferDetailsCubit(
      loadOfferById: _loadOfferById,
      offerId: _successOfferId,
    ),
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        busy: false,
        offer: _offer,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.getOffer(
          id: _successOfferId,
          forceRefresh: true,
          latitudeForDistance: null,
          longitudeForDistance: null,
        ),
      ).called(1);
    },
  ); // should force load an offer

  blocTest<OfferDetailsCubit, OfferDetailsState>(
    'should load using all parameters',
    build: () => OfferDetailsCubit(
      loadOfferById: _loadOfferById,
      offerId: _successOfferId,
    ),
    act: (c) => c.load(
      latitude: _latitude,
      longitude: _longitude,
    ),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(
        busy: false,
        offer: _offer,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.getOffer(
          id: _successOfferId,
          forceRefresh: false,
          latitudeForDistance: _latitude,
          longitudeForDistance: _longitude,
        ),
      ).called(1);
    },
  ); // should load using all parameters

  blocTest<OfferDetailsCubit, OfferDetailsState>(
    'should handle NetException',
    build: () => OfferDetailsCubit(
      loadOfferById: _loadOfferById,
      offerId: _netErrorOfferId,
    ),
    act: (c) => c.load(),
    expect: () => [
      defaultState.copyWith(
        offerId: _netErrorOfferId,
        busy: true,
      ),
      defaultState.copyWith(
        offerId: _netErrorOfferId,
        error: OfferDetailsStateError.network,
        errorMessage: _netException.message,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.getOffer(
          id: _netErrorOfferId,
          forceRefresh: false,
          latitudeForDistance: null,
          longitudeForDistance: null,
        ),
      ).called(1);
    },
  ); // should handle NetException

  blocTest<OfferDetailsCubit, OfferDetailsState>(
    'should handle generic exceptions',
    build: () => OfferDetailsCubit(
      loadOfferById: _loadOfferById,
      offerId: _genericErrorOfferId,
    ),
    act: (c) => c.load(),
    expect: () => [
      defaultState.copyWith(
        offerId: _genericErrorOfferId,
        busy: true,
      ),
      defaultState.copyWith(
        offerId: _genericErrorOfferId,
        error: OfferDetailsStateError.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.getOffer(
          id: _genericErrorOfferId,
          forceRefresh: false,
          latitudeForDistance: null,
          longitudeForDistance: null,
        ),
      ).called(1);
    },
  ); // should handle generic exceptions
}
