import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/features/cards.dart';
import 'package:layer_sdk/features/financial_data.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCardRepository extends Mock implements CardRepositoryInterface {}

class MockFinancialDataRepository extends Mock
    implements FinancialDataRepositoryInterface {}

void main() {
  late CardRepositoryInterface _cardRepository;
  late FinancialDataRepositoryInterface _financialDataRepository;
  late LoadCustomerCardsUseCase _getCustomerCardsUseCase;
  late LoadFinancialDataUseCase _getFinancialDataUseCase;
  late CardDashboardCubit _cubit;
  late List<BankingCard> _mockedCards;
  late FinancialData _mockedFinancialData;

  setUp(
    () {
      _mockedCards = List.generate(
        1,
        (index) => BankingCard(
          cardId: index.toString(),
          status: CardStatus.active,
          maskedCardNumber: '$index***$index',
          preferences: CardPreferences(),
          type: CardType(category: CardCategory.prepaid),
        ),
      );
      _mockedFinancialData = FinancialData(
        availableCredit: 30.0,
        cardBalance: 20.0,
        prefCurrency: 'BRL',
      );
      _cardRepository = MockCardRepository();
      _financialDataRepository = MockFinancialDataRepository();
      _getCustomerCardsUseCase = LoadCustomerCardsUseCase(
        repository: _cardRepository,
      );
      _getFinancialDataUseCase = LoadFinancialDataUseCase(
        repository: _financialDataRepository,
      );
      _cubit = CardDashboardCubit(
        getCustomerCardsUseCase: _getCustomerCardsUseCase,
        getFinancialDataUseCase: _getFinancialDataUseCase,
      );
    },
  );

  blocTest<CardDashboardCubit, CardDashboardState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) {
      expect(c.state, CardDashboardState());
    },
  );

  group("Cards", () {
    blocTest<CardDashboardCubit, CardDashboardState>(
      'Loads customer cards',
      setUp: () {
        when(() => _cardRepository.listCustomerCards()).thenAnswer(
          (_) async => _mockedCards,
        );
      },
      build: () => _cubit,
      act: (c) => c.loadCards(),
      expect: () => [
        CardDashboardState(
          actions: {
            CardDashboardAction.loadCards,
          },
          errors: {},
        ),
        CardDashboardState(actions: {}, errors: {}, cards: _mockedCards),
      ],
      verify: (c) {
        verify(
          () => _cardRepository.listCustomerCards(),
        ).called(1);
      },
    );

    blocTest<CardDashboardCubit, CardDashboardState>(
      'Handle exception',
      setUp: () {
        when(() => _cardRepository.listCustomerCards())
            .thenThrow(NetException());
      },
      build: () => _cubit,
      act: (c) => c.loadCards(),
      expect: () => [
        CardDashboardState(
          actions: {
            CardDashboardAction.loadCards,
          },
          errors: {},
        ),
        CardDashboardState(actions: {}, errors: {
          CubitAPIError<CardDashboardAction>(
            action: CardDashboardAction.loadCards,
            code: CubitErrorCode.fromString(null),
          )
        }),
      ],
      verify: (c) {
        verify(
          () => _cardRepository.listCustomerCards(),
        ).called(1);
      },
    );
  });

  group("Financial data", () {
    blocTest<CardDashboardCubit, CardDashboardState>(
      'Loads financial data',
      setUp: () {
        when(() => _financialDataRepository.loadFinancialData()).thenAnswer(
          (_) async => _mockedFinancialData,
        );
      },
      build: () => _cubit,
      act: (c) => c.loadFinancialData(),
      expect: () => [
        CardDashboardState(
          actions: {
            CardDashboardAction.loadFinancialData,
          },
          errors: {},
        ),
        CardDashboardState(
          actions: {},
          errors: {},
          financialData: _mockedFinancialData,
        ),
      ],
      verify: (c) {
        verify(
          () => _financialDataRepository.loadFinancialData(),
        ).called(1);
      },
    );

    blocTest<CardDashboardCubit, CardDashboardState>(
      'Handle exception',
      setUp: () {
        when(() => _financialDataRepository.loadFinancialData())
            .thenThrow(NetException());
      },
      build: () => _cubit,
      act: (c) => c.loadFinancialData(),
      expect: () => [
        CardDashboardState(
          actions: {
            CardDashboardAction.loadFinancialData,
          },
          errors: {},
        ),
        CardDashboardState(actions: {}, errors: {
          CubitAPIError<CardDashboardAction>(
            action: CardDashboardAction.loadFinancialData,
            code: CubitErrorCode.fromString(null),
          )
        }),
      ],
      verify: (c) {
        verify(
          () => _financialDataRepository.loadFinancialData(),
        ).called(1);
      },
    );
  });
}
