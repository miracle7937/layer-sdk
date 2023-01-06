import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';

void main() {
  late List<AgentACL> acls;
  late List<BankingCard> cards;
  late List<BankingCard> expectedCards;
  late FilterAgentVisibleCardsUseCase _useCase;

  setUp(() {
    acls = List.generate(
      5,
      (index) => AgentACL(
        aclId: index,
        cardId: index % 2 == 0 ? index.toString() : '',
        accountId: '',
      ),
    );

    cards = List.generate(
      5,
      (index) => BankingCard(
        cardId: index.toString(),
        status: CardStatus.active,
        preferences: CardPreferences(),
      ),
    );

    expectedCards = [
      cards[0],
      cards[2],
      cards[4],
    ];

    _useCase = FilterAgentVisibleCardsUseCase();
  });

  test('Should return correct list of cards', () async {
    final result = _useCase(
      acls: acls,
      cards: cards,
    );

    expect(result, expectedCards);
  });
}
