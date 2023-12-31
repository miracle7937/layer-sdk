import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllLoyaltyPointsUseCase extends Mock
    implements LoadAllLoyaltyPointsUseCase {}

class MockLoadCurrentLoyaltyPointsRateUseCase extends Mock
    implements LoadCurrentLoyaltyPointsRateUseCase {}

class MockLoadExpiredLoyaltyPointsByDateUseCase extends Mock
    implements LoadExpiredLoyaltyPointsByDateUseCase {}

class MockLoadOffersUseCase extends Mock implements LoadOffersUseCase {}

class MockLoadCategoriesUseCase extends Mock implements LoadCategoriesUseCase {}

late LoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;

late LoadCurrentLoyaltyPointsRateUseCase _loadCurrentLoyaltyPointsRateUseCase;

late LoadExpiredLoyaltyPointsByDateUseCase
    _loadExpiredLoyaltyPointsByDateUseCase;

late LoadOffersUseCase _loadOffersUseCase;

late LoadCategoriesUseCase _loadCategoriesUseCase;

late LoyaltyLandingCubit _cubit;

void main() {
  final _mockedPoints = List.generate(
    3,
    (index) => LoyaltyPoints(
      id: 0,
    ),
  );

  final _mockedCategories = List.generate(
    3,
    (index) => Category(),
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

    _loadCategoriesUseCase = MockLoadCategoriesUseCase();

    _cubit = LoyaltyLandingCubit(
      loadAllLoyaltyPointsUseCase: _loadAllLoyaltyPointsUseCase,
      loadCurrentLoyaltyPointsRateUseCase: _loadCurrentLoyaltyPointsRateUseCase,
      loadExpiredLoyaltyPointsByDateUseCase:
          _loadExpiredLoyaltyPointsByDateUseCase,
      loadOffersUseCase: _loadOffersUseCase,
      loadCategoriesUseCase: _loadCategoriesUseCase,
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

    when(
      () => _loadCategoriesUseCase(),
    ).thenAnswer(
      (_) async => _mockedCategories,
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
        offers: {},
        categories: {},
        loyaltyPoints: null,
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
        loyaltyPoints: _mockedPoints.first,
        offers: _mockedOffer.offers,
        loyaltyPointsRate: _mockedLoyaltyPointsRate,
        loyaltyPointsExpiration: _mockedLoyaltyPointsExpiration,
        categories: _mockedCategories,
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
        loyaltyPoints: _mockedPoints.first,
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

  blocTest<LoyaltyLandingCubit, LoyaltyLandingState>(
    'Should return a list of categories',
    build: () => _cubit,
    act: (c) => c.loadCategories(),
    expect: () => [
      LoyaltyLandingState(
        actions: {LoyaltyLandingActions.loadCategories},
        errors: {},
      ),
      LoyaltyLandingState(
        actions: {},
        errors: {},
        categories: _mockedCategories,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadCategoriesUseCase(),
      ).called(1);
    },
  );
}
