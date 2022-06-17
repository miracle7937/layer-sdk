import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories/card/card_repository_interface.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/card/load_customer_cards_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockCardRepositoryInterface extends Mock
    implements CardRepositoryInterface {}

late MockCardRepositoryInterface _cardRepositoryInterface;
late LoadCustomerCardsUseCase _useCase;
late List<BankingCard> _cards;

void main() {
  _cardRepositoryInterface = MockCardRepositoryInterface();
  _useCase = LoadCustomerCardsUseCase(
    repository: _cardRepositoryInterface,
  );

  _cards = List.generate(
    5,
    (index) => BankingCard(
      cardId: '$index',
      status: CardStatus.active,
      preferences: CardPreferences(),
    ),
  );

  setUpAll(
    () => {
      when(
        () => _cardRepositoryInterface.listCustomerCards(
          customerId: any(named: 'customerId'),
        ),
      ).thenAnswer(
        (_) async => _cards,
      )
    },
  );

  test('Should return correct cards list', () async {
    final result = await _useCase(customerId: 'thisisatest');

    expect(result, _cards);

    verify(
      () => _cardRepositoryInterface.listCustomerCards(
        customerId: 'thisisatest',
      ),
    ).called(1);
  });
}
