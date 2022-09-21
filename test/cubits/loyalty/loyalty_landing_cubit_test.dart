import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:layer_sdk/presentation_layer/cubits/loyalty/loyalty_landing/loyalty_landing_cubit.dart';
import 'package:layer_sdk/presentation_layer/cubits/loyalty/loyalty_landing/loyalty_landing_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllLoyaltyPointsUseCase extends Mock
    implements LoadAllLoyaltyPointsUseCase {}

class MockLoadCurrentLoyaltyPointsRateUseCase extends Mock
    implements LoadCurrentLoyaltyPointsRateUseCase {}

class MockLoadExpiredLoyaltyPointsByDateUseCase extends Mock
    implements LoadExpiredLoyaltyPointsByDateUseCase {}

class MockLoadOffersUseCase extends Mock implements LoadOffersUseCase {}

late LoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;

late LoadCurrentLoyaltyPointsRateUseCase _loadCurrentLoyaltyPointsRateUseCase;

late LoadExpiredLoyaltyPointsByDateUseCase
    _loadExpiredLoyaltyPointsByDateUseCase;

late LoadOffersUseCase _loadOffersUseCase;

late LoyaltyLandingCubit _cubit;

void main() {
  final _mockedPoints = List.generate(
    3,
    (index) => LoyaltyPoints(
      id: 0,
    ),
  );

  final _mockedLoyaltyPointsRate = LoyaltyPointsRate(
    id: '0',
    rate: 1,
  );

  final _mockedLoyaltyPointsExpiration = LoyaltyPointsExpiration(
    amount: 1,
  );

  final _mockedOffer = OfferResponse(
    totalCount: 1,
    offers: List.generate(
      3,
      (index) => Offer(
        id: 1,
        status: OfferStatus.active,
        merchant: Merchant(),
        type: OfferType.bankCampaign,
      ),
    ),
  );

  final _now = DateTime.now();

  setUp(() {
    _loadAllLoyaltyPointsUseCase = MockLoadAllLoyaltyPointsUseCase();

    _loadCurrentLoyaltyPointsRateUseCase =
        MockLoadCurrentLoyaltyPointsRateUseCase();

    _loadExpiredLoyaltyPointsByDateUseCase =
        MockLoadExpiredLoyaltyPointsByDateUseCase();

    _loadOffersUseCase = MockLoadOffersUseCase();

    _cubit = LoyaltyLandingCubit(
      loadAllLoyaltyPointsUseCase: _loadAllLoyaltyPointsUseCase,
      loadCurrentLoyaltyPointsRateUseCase: _loadCurrentLoyaltyPointsRateUseCase,
      loadExpiredLoyaltyPointsByDateUseCase:
          _loadExpiredLoyaltyPointsByDateUseCase,
      loadOffersUseCase: _loadOffersUseCase,
    );

    when(() => _loadAllLoyaltyPointsUseCase()).thenAnswer(
      (_) async => _mockedPoints,
    );

    when(() => _loadCurrentLoyaltyPointsRateUseCase()).thenAnswer(
      (_) async => _mockedLoyaltyPointsRate,
    );

    when(
      () => _loadExpiredLoyaltyPointsByDateUseCase(
        expirationDate: _now,
      ),
    ).thenAnswer(
      (_) async => _mockedLoyaltyPointsExpiration,
    );

    when(
      () => _loadOffersUseCase(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (_) async => _mockedOffer,
    );
  });

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      LoyaltyLandingState(
        actions: {},
        errors: {},
        loyaltyPoints: {},
        offers: {},
        loyaltyPointsRate: null,
        loyaltyPointsExpiration: null,
      ),
    ),
  );

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Initialize should return all necessary data for landing loyalty',
    build: () => _cubit,
    act: (c) => c.initialize(expirationDate: _now),
    verify: (c) => expect(
      c.state,
      LoyaltyLandingState(
        loyaltyPoints: _mockedPoints,
        offers: _mockedOffer.offers,
        loyaltyPointsRate: _mockedLoyaltyPointsRate,
        loyaltyPointsExpiration: _mockedLoyaltyPointsExpiration,
      ),
    ),
  );

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Should return a list of loyalty points',
    build: () => _cubit,
    act: (c) => c.loadAllLoyaltyPoints(),
    expect: () => [
      LoyaltyLandingState(
        actions: {LoyaltyLandingActions.loadAllLoyaltyPoints},
        errors: {},
      ),
      LoyaltyLandingState(
        actions: {},
        errors: {},
        loyaltyPoints: _mockedPoints,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadAllLoyaltyPointsUseCase(),
      ).called(1);
    },
  );

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Should return the current loyalty points rate',
    build: () => _cubit,
    act: (c) => c.loadCurrentLoyaltyPointsRate(),
    expect: () => [
      LoyaltyLandingState(
        actions: {LoyaltyLandingActions.loadCurrentLoyaltyPoints},
        errors: {},
      ),
      LoyaltyLandingState(
        actions: {},
        errors: {},
        loyaltyPointsRate: _mockedLoyaltyPointsRate,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadCurrentLoyaltyPointsRateUseCase(),
      ).called(1);
    },
  );

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Should return the expired loyalty points',
    build: () => _cubit,
    act: (c) => c.loadExpiredLoyaltyPoints(expirationDate: _now),
    expect: () => [
      LoyaltyLandingState(
        actions: {LoyaltyLandingActions.loadExpiredLoyaltyPoints},
        errors: {},
      ),
      LoyaltyLandingState(
        actions: {},
        errors: {},
        loyaltyPointsExpiration: _mockedLoyaltyPointsExpiration,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadExpiredLoyaltyPointsByDateUseCase(expirationDate: _now),
      ).called(1);
    },
  );

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Should return a list of offers',
    build: () => _cubit,
    act: (c) => c.loadOffers(),
    expect: () => [
      LoyaltyLandingState(
        actions: {LoyaltyLandingActions.loadOffers},
        errors: {},
      ),
      LoyaltyLandingState(
        actions: {},
        errors: {},
        offers: _mockedOffer.offers,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadOffersUseCase(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).called(1);
    },
  );
}
