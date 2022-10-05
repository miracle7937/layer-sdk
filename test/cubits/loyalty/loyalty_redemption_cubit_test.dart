import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllCurrenciesUseCase extends Mock
    implements LoadAllCurrenciesUseCase {}

class MockLoadAllLoyaltyPointsUseCase extends Mock
    implements LoadAllLoyaltyPointsUseCase {}

class MockLoadCurrentLoyaltyPointsRateUseCase extends Mock
    implements LoadCurrentLoyaltyPointsRateUseCase {}

class MockLoadExpiredLoyaltyPointsByDateUseCase extends Mock
    implements LoadExpiredLoyaltyPointsByDateUseCase {}

class MockExchangeLoyaltyPointsUseCase extends Mock
    implements ExchangeLoyaltyPointsUseCase {}

class MockGetAccountsByStatusUseCase extends Mock
    implements GetAccountsByStatusUseCase {}

class MockLoadGlobalSettingsUseCase extends Mock
    implements LoadGlobalSettingsUseCase {}

late MockLoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
late MockLoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;
late MockLoadCurrentLoyaltyPointsRateUseCase
    _loadCurrentLoyaltyPointsRateUseCase;
late MockLoadExpiredLoyaltyPointsByDateUseCase
    _loadExpiredLoyaltyPointsByDateUseCase;
late MockExchangeLoyaltyPointsUseCase _exchangeLoyaltyPointsUseCase;
late MockGetAccountsByStatusUseCase _getAccountsByStatusUseCase;
late MockLoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

late LoyaltyRedemptionCubit _cubit;

void main() {
  final baseCurrencyCode = 'GBP';

  final currency1 = Currency(code: 'EUR');
  final currency2 = Currency(code: baseCurrencyCode);
  final currencies = [currency1, currency2];

  final account1 = Account(id: 'account1');
  final account2 = Account(id: 'account2');
  final accounts = [account1, account2];

  final loyaltyPoints = LoyaltyPoints(
    id: 0,
    balance: 10,
  );

  final pointsRate = LoyaltyPointsRate(
    id: '0',
    rate: 1,
  );

  final loyaltyPointsExpiration = LoyaltyPointsExpiration(
    amount: 1,
  );

  final expiryDate = DateTime.now();

  final _globalSettingList = [
    GlobalSetting(
      code: 'base_currency',
      module: 'module',
      value: baseCurrencyCode,
      type: GlobalSettingType.string,
    ),
  ];

  setUp(() {
    _loadAllCurrenciesUseCase = MockLoadAllCurrenciesUseCase();
    _loadAllLoyaltyPointsUseCase = MockLoadAllLoyaltyPointsUseCase();
    _loadCurrentLoyaltyPointsRateUseCase =
        MockLoadCurrentLoyaltyPointsRateUseCase();
    _loadExpiredLoyaltyPointsByDateUseCase =
        MockLoadExpiredLoyaltyPointsByDateUseCase();
    _exchangeLoyaltyPointsUseCase = MockExchangeLoyaltyPointsUseCase();
    _getAccountsByStatusUseCase = MockGetAccountsByStatusUseCase();
    _loadGlobalSettingsUseCase = MockLoadGlobalSettingsUseCase();

    _cubit = LoyaltyRedemptionCubit(
      loadAllCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadAllLoyaltyPointsUseCase: _loadAllLoyaltyPointsUseCase,
      loadCurrentLoyaltyPointsRateUseCase: _loadCurrentLoyaltyPointsRateUseCase,
      loadExpiredLoyaltyPointsByDateUseCase:
          _loadExpiredLoyaltyPointsByDateUseCase,
      exchangeLoyaltyPointsUseCase: _exchangeLoyaltyPointsUseCase,
      getAccountsByStatusUseCase: _getAccountsByStatusUseCase,
      expiryDate: expiryDate,
      loadGlobalSettingsUseCase: _loadGlobalSettingsUseCase,
    );

    when(
      _loadAllCurrenciesUseCase,
    ).thenAnswer(
      (_) async => currencies,
    );

    when(
      () => _getAccountsByStatusUseCase(statuses: [AccountStatus.active]),
    ).thenAnswer(
      (_) async => accounts,
    );

    when(
      _loadCurrentLoyaltyPointsRateUseCase,
    ).thenAnswer(
      (_) async => pointsRate,
    );

    when(
      _loadAllLoyaltyPointsUseCase,
    ).thenAnswer(
      (_) async => [loyaltyPoints],
    );

    when(
      () => _loadExpiredLoyaltyPointsByDateUseCase(
        expirationDate: expiryDate,
      ),
    ).thenAnswer(
      (_) async => loyaltyPointsExpiration,
    );

    when(
      () => _loadGlobalSettingsUseCase(
        codes: ['base_currency'],
      ),
    ).thenAnswer(
      (_) async => _globalSettingList,
    );
  });

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(),
    ),
  );

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data',
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        currencies: currencies,
        accounts: accounts,
        loyaltyPoints: loyaltyPoints.copyWith(
          rate: pointsRate.rate.toDouble(),
          dueExpiryPoints: loyaltyPointsExpiration.amount,
        ),
        baseCurrencyCode: baseCurrencyCode,
      ),
    ),
  );

  final exception = NetException(message: 'Net error');

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data, '
    'loading currencies fails',
    setUp: () {
      when(
        _loadAllCurrenciesUseCase,
      ).thenAnswer(
        (_) async => throw exception,
      );
    },
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        accounts: accounts,
        loyaltyPoints: loyaltyPoints.copyWith(
          rate: pointsRate.rate.toDouble(),
          dueExpiryPoints: loyaltyPointsExpiration.amount,
        ),
        baseCurrencyCode: baseCurrencyCode,
        errors: {
          CubitAPIError<LoyaltyRedemptionAction>(
            action: LoyaltyRedemptionAction.currencies,
            code: CubitErrorCode.unknown,
            message: exception.message,
          )
        },
      ),
    ),
  );

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data, '
    'loading accounts fails',
    setUp: () {
      when(
        () => _getAccountsByStatusUseCase(statuses: [AccountStatus.active]),
      ).thenAnswer(
        (_) async => throw exception,
      );
    },
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        currencies: currencies,
        loyaltyPoints: loyaltyPoints.copyWith(
          rate: pointsRate.rate.toDouble(),
          dueExpiryPoints: loyaltyPointsExpiration.amount,
        ),
        baseCurrencyCode: baseCurrencyCode,
        errors: {
          CubitAPIError<LoyaltyRedemptionAction>(
            action: LoyaltyRedemptionAction.accounts,
            code: CubitErrorCode.unknown,
            message: exception.message,
          )
        },
      ),
    ),
  );

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data, '
    'loading points fails',
    setUp: () {
      when(
        _loadAllLoyaltyPointsUseCase,
      ).thenAnswer(
        (_) async => throw exception,
      );
    },
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        currencies: currencies,
        accounts: accounts,
        loyaltyPoints: LoyaltyPoints(
          id: -1,
          rate: pointsRate.rate.toDouble(),
          dueExpiryPoints: loyaltyPointsExpiration.amount,
        ),
        baseCurrencyCode: baseCurrencyCode,
        errors: {
          CubitAPIError<LoyaltyRedemptionAction>(
            action: LoyaltyRedemptionAction.points,
            code: CubitErrorCode.unknown,
            message: exception.message,
          )
        },
      ),
    ),
  );

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data, '
    'loading points rate fails',
    setUp: () {
      when(
        _loadCurrentLoyaltyPointsRateUseCase,
      ).thenAnswer(
        (_) async => throw exception,
      );
    },
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        currencies: currencies,
        accounts: accounts,
        loyaltyPoints: loyaltyPoints.copyWith(
          dueExpiryPoints: loyaltyPointsExpiration.amount,
        ),
        baseCurrencyCode: baseCurrencyCode,
        errors: {
          CubitAPIError<LoyaltyRedemptionAction>(
            action: LoyaltyRedemptionAction.rate,
            code: CubitErrorCode.unknown,
            message: exception.message,
          )
        },
      ),
    ),
  );

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data, '
    'loading expired points fails',
    setUp: () {
      when(
        () => _loadExpiredLoyaltyPointsByDateUseCase(
          expirationDate: expiryDate,
        ),
      ).thenAnswer(
        (_) async => throw exception,
      );
    },
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        currencies: currencies,
        accounts: accounts,
        loyaltyPoints: loyaltyPoints.copyWith(
          rate: pointsRate.rate.toDouble(),
        ),
        baseCurrencyCode: baseCurrencyCode,
        errors: {
          CubitAPIError<LoyaltyRedemptionAction>(
            action: LoyaltyRedemptionAction.expiredPoints,
            code: CubitErrorCode.unknown,
            message: exception.message,
          )
        },
      ),
    ),
  );

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Loads all init required data, '
    'loading base currency fails',
    setUp: () {
      when(
        () => _loadGlobalSettingsUseCase(
          codes: ['base_currency'],
        ),
      ).thenAnswer(
        (_) async => throw exception,
      );
    },
    build: () => _cubit,
    act: (c) => c.initialize(),
    verify: (c) => expect(
      c.state,
      LoyaltyRedemptionState(
        currencies: currencies,
        accounts: accounts,
        loyaltyPoints: loyaltyPoints.copyWith(
          rate: pointsRate.rate.toDouble(),
          dueExpiryPoints: loyaltyPointsExpiration.amount,
        ),
        errors: {
          CubitAPIError<LoyaltyRedemptionAction>(
            action: LoyaltyRedemptionAction.baseCurrency,
            code: CubitErrorCode.unknown,
            message: exception.message,
          )
        },
      ),
    ),
  );

  final preExchangeState = LoyaltyRedemptionState(
    currencies: currencies,
    accounts: accounts,
    loyaltyPoints: loyaltyPoints.copyWith(
      rate: pointsRate.rate.toDouble(),
      dueExpiryPoints: loyaltyPointsExpiration.amount,
    ),
    baseCurrencyCode: baseCurrencyCode,
  );

  final exchangeResult = LoyaltyPointsExchange(loyaltyId: 0);

  blocTest<LoyaltyRedemptionCubit, LoyaltyRedemptionState>(
    'Exchanges points, emits result',
    setUp: () => when(
      () => _exchangeLoyaltyPointsUseCase(
        amount: loyaltyPoints.balance,
        accountId: account1.id,
      ),
    ).thenAnswer(
      (_) async => exchangeResult,
    ),
    build: () => _cubit,
    seed: () => preExchangeState,
    act: (c) => c.exchange(),
    expect: () => [
      preExchangeState.copyWith(
        actions: {LoyaltyRedemptionAction.exchange},
      ),
      preExchangeState.copyWith(
        exchangeResult: exchangeResult,
        events: {LoyaltyRedemptionEvent.showResultView},
      )
    ],
  );
}
