import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/data_layer/repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/card/load_customer_cards_use_case.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCardRepository extends Mock implements CardRepository {}

late MockCardRepository _repo;
late LoadCustomerCardsUseCase _getCustomerCardsUseCase;

final loadCardsCustomerId = '1';
final throwsExceptionCustomerId = '2';

void main() {
  final mockedCards = List.generate(
    20,
    (index) => BankingCard(
      cardId: index.toString(),
      status: CardStatus.active,
      maskedCardNumber: '$index***$index',
      preferences: CardPreferences(),
      type: CardType(category: CardCategory.prepaid),
    ),
  );

  setUpAll(
    () {
      _repo = MockCardRepository();
      _getCustomerCardsUseCase = LoadCustomerCardsUseCase(
        repository: _repo,
      );

      /// Test case that retrieves all mocked cards
      when(
        () => _repo.listCustomerCards(
          customerId: loadCardsCustomerId,
        ),
      ).thenAnswer(
        (_) async => mockedCards,
      );

      /// Test case that throws Exception
      when(
        () => _repo.listCustomerCards(
          customerId: throwsExceptionCustomerId,
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some Error'),
      );
    },
  );

  blocTest<CardCubit, CardState>(
    'Starts with empty state',
    build: () => CardCubit(
      getCustomerCardsUseCase: _getCustomerCardsUseCase,
      customerId: loadCardsCustomerId,
    ),
    verify: (c) {
      expect(c.state, CardState(customerId: loadCardsCustomerId));
    },
  );

  blocTest<CardCubit, CardState>(
    'Loads customer cards',
    build: () => CardCubit(
      getCustomerCardsUseCase: _getCustomerCardsUseCase,
      customerId: loadCardsCustomerId,
    ),
    act: (c) => c.load(),
    expect: () => [
      CardState(busy: true, customerId: loadCardsCustomerId),
      CardState(
        customerId: loadCardsCustomerId,
        cards: mockedCards,
        error: CardStateErrors.none,
        busy: false,
      )
    ],
    verify: (c) {
      verify(
        () => _repo.listCustomerCards(
          customerId: loadCardsCustomerId,
        ),
      ).called(1);
    },
  );

  blocTest<CardCubit, CardState>(
    'Handles exceptions gracefully',
    build: () => CardCubit(
      getCustomerCardsUseCase: _getCustomerCardsUseCase,
      customerId: throwsExceptionCustomerId,
    ),
    act: (c) => c.load(),
    expect: () => [
      CardState(
        busy: true,
        customerId: throwsExceptionCustomerId,
      ),
      CardState(
        customerId: throwsExceptionCustomerId,
        cards: [],
        error: CardStateErrors.generic,
        busy: false,
      )
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repo.listCustomerCards(
          customerId: throwsExceptionCustomerId,
        ),
      ).called(1);
    },
  );
}
