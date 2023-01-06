import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadCustomerRolesUseCase extends Mock
    implements LoadCustomerRolesUseCase {}

class MockLoadCustomerCardsUseCase extends Mock
    implements LoadCustomerCardsUseCase {}

class MockGetCustomerAccountsUseCase extends Mock
    implements GetCustomerAccountsUseCase {}

class MockLoadAgentACLUseCase extends Mock implements LoadAgentACLUseCase {}

void main() {
  final corporationId = 'corporationId';

  late MockGetCustomerAccountsUseCase loadAccountsUseCase;
  late MockLoadAgentACLUseCase loadAgentACLUseCase;
  late MockLoadCustomerCardsUseCase loadCardsUseCase;

  final cards = [
    BankingCard(
      cardId: 'cardId1',
      status: null,
      preferences: CardPreferences(),
    ),
    BankingCard(
      cardId: 'cardId2',
      status: null,
      preferences: CardPreferences(),
    ),
    BankingCard(
      cardId: 'cardId3',
      status: null,
      preferences: CardPreferences(),
    ),
  ];

  final accounts = [
    Account(id: 'id1'),
    Account(id: 'id2'),
    Account(id: 'id3'),
  ];

  final acl = [
    AgentACL(aclId: 1),
    AgentACL(aclId: 2),
  ];

  setUpAll(() {
    loadAgentACLUseCase = MockLoadAgentACLUseCase();
    loadAccountsUseCase = MockGetCustomerAccountsUseCase();
    loadCardsUseCase = MockLoadCustomerCardsUseCase();

    when(
      () => loadAgentACLUseCase.call(
          status: any(named: 'status'),
          userId: any(named: 'userId'),
          username: any(
            named: 'username',
          )),
    ).thenAnswer(
      (_) async => acl,
    );
    when(
      () => loadAccountsUseCase.call(
        customerId: any(named: 'customerId'),
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
        statuses: any(named: 'statuses'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => accounts,
    );
    when(
      () => loadCardsUseCase.call(
        customerId: any(named: 'customerId'),
        includeDetails: any(named: 'includeDetails'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => cards,
    );
  });

  blocTest<NewAgentVisibilityStepCubit, NewAgentVisibilityStepState>(
    'Loads cards and accounts',
    build: () => NewAgentVisibilityStepCubit(
      corporationId: corporationId,
      loadCardsUseCase: loadCardsUseCase,
      loadAccountsUseCase: loadAccountsUseCase,
      loadAgentACLUseCase: loadAgentACLUseCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      NewAgentVisibilityStepState(
        corporationId: corporationId,
        busy: true,
      ),
      NewAgentVisibilityStepState(
        corporationId: corporationId,
        cards: cards,
        accounts: accounts,
      ),
    ],
  );

  blocTest<NewAgentVisibilityStepCubit, NewAgentVisibilityStepState>(
    'Selects new card',
    build: () => NewAgentVisibilityStepCubit(
      corporationId: corporationId,
      loadCardsUseCase: loadCardsUseCase,
      loadAccountsUseCase: loadAccountsUseCase,
      loadAgentACLUseCase: loadAgentACLUseCase,
    ),
    seed: () {
      return NewAgentVisibilityStepState(
        corporationId: corporationId,
        cards: cards,
        visibleCards: cards.take(2),
        accounts: accounts,
        visibleAccounts: accounts.take(2),
        action: StepsStateAction.editAction,
      );
    },
    act: (c) => c.onCardTap(cards.last),
    expect: () => [
      NewAgentVisibilityStepState(
        corporationId: corporationId,
        cards: cards,
        visibleCards: cards,
        accounts: accounts,
        visibleAccounts: accounts.take(2),
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentVisibilityStepCubit, NewAgentVisibilityStepState>(
    'Selects new account',
    build: () => NewAgentVisibilityStepCubit(
      corporationId: corporationId,
      loadCardsUseCase: loadCardsUseCase,
      loadAccountsUseCase: loadAccountsUseCase,
      loadAgentACLUseCase: loadAgentACLUseCase,
    ),
    seed: () {
      return NewAgentVisibilityStepState(
        corporationId: corporationId,
        cards: cards,
        visibleCards: cards.take(2),
        accounts: accounts,
        visibleAccounts: accounts.take(2),
        action: StepsStateAction.editAction,
      );
    },
    act: (c) => c.onAccountTap(accounts.last),
    expect: () => [
      NewAgentVisibilityStepState(
        corporationId: corporationId,
        cards: cards,
        visibleCards: cards.take(2),
        accounts: accounts,
        visibleAccounts: accounts,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentVisibilityStepCubit, NewAgentVisibilityStepState>(
    'onContinue emits nothing',
    build: () => NewAgentVisibilityStepCubit(
      corporationId: corporationId,
      loadCardsUseCase: loadCardsUseCase,
      loadAccountsUseCase: loadAccountsUseCase,
      loadAgentACLUseCase: loadAgentACLUseCase,
    ),
    seed: () {
      return NewAgentVisibilityStepState(
        corporationId: corporationId,
        cards: cards,
        visibleCards: cards.take(2),
        accounts: accounts,
        visibleAccounts: accounts.take(2),
        action: StepsStateAction.editAction,
      );
    },
    act: (c) => c.onContinue(),
    expect: () => [],
  );
}
