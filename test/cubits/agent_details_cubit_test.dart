import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCustomerAccountsUseCase extends Mock
    implements GetCustomerAccountsUseCase {}

class MockLoadCustomerCardsUseCase extends Mock
    implements LoadCustomerCardsUseCase {}

class MockLoadAgentACLUseCase extends Mock implements LoadAgentACLUseCase {}

class MockUpdateAgentAccountVisibilityUseCase extends Mock
    implements UpdateAgentAccountVisibilityUseCase {}

class MockUpdateAgentCardVisibilityUseCase extends Mock
    implements UpdateAgentCardVisibilityUseCase {}

class MockRequestPasswordResetUseCase extends Mock
    implements RequestPasswordResetUseCase {}

class MockDeleteAgentUseCase extends Mock implements DeleteAgentUseCase {}

class MockRequestLockUseCase extends Mock implements RequestLockUseCase {}

class MockRequestDeactivateUseCase extends Mock
    implements RequestDeactivateUseCase {}

class MockRequestActivateUseCase extends Mock
    implements RequestActivateUseCase {}

class MockFilterAgentVisibileAccountsUseCase extends Mock
    implements FilterAgentVisibleAccountsUseCase {}

class MockFilterAgentVisibileCardsUseCase extends Mock
    implements FilterAgentVisibleCardsUseCase {}

late List<BankingCard> _cards;
late List<Account> _accounts;
late List<AgentACL> _acls;
late MockGetCustomerAccountsUseCase _customerAccountsUseCase;
late MockRequestPasswordResetUseCase _requestPasswordResetUseCase;
late MockDeleteAgentUseCase _deleteAgentUseCase;
late MockRequestLockUseCase _requestLockUseCase;
late MockRequestDeactivateUseCase _requestDeactivateUseCase;
late MockRequestActivateUseCase _requestActivateUseCase;
late MockLoadCustomerCardsUseCase _cardsUseCase;
late MockLoadAgentACLUseCase _aclUseCase;
late MockUpdateAgentAccountVisibilityUseCase _updateAccountVisibilityUseCase;
late MockUpdateAgentCardVisibilityUseCase _updateCardVisibilityUseCase;
late MockFilterAgentVisibileAccountsUseCase _filterAgentVisibileAccountsUseCase;
late MockFilterAgentVisibileCardsUseCase _filterAgentVisibileCardsUseCase;
late String _successId;
late String _failureId;
late String _emptyId;
late String _corporationId;
late Customer _corporation;
late User _agent;
late User _emptyAgent;
late User _exceptionAgent;

AgentDetailsCubit create({
  User? agent,
}) =>
    AgentDetailsCubit(
      accountsUseCase: _customerAccountsUseCase,
      aclUseCase: _aclUseCase,
      cardsUseCase: _cardsUseCase,
      updateAccountVisibilityUseCase: _updateAccountVisibilityUseCase,
      updateCardVisibilityUseCase: _updateCardVisibilityUseCase,
      agent: agent ?? _agent,
      corporation: _corporation,
      deleteAgentUseCase: _deleteAgentUseCase,
      requestActivateUseCase: _requestActivateUseCase,
      requestDeactivateUseCase: _requestDeactivateUseCase,
      requestLockUseCase: _requestLockUseCase,
      requestPasswordResetUseCase: _requestPasswordResetUseCase,
      filterAgentVisibleAccountsUseCase: _filterAgentVisibileAccountsUseCase,
      filterAgentVisibleCardsUseCase: _filterAgentVisibileCardsUseCase,
    );

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _customerAccountsUseCase = MockGetCustomerAccountsUseCase();
    _cardsUseCase = MockLoadCustomerCardsUseCase();
    _aclUseCase = MockLoadAgentACLUseCase();
    _updateAccountVisibilityUseCase = MockUpdateAgentAccountVisibilityUseCase();
    _updateCardVisibilityUseCase = MockUpdateAgentCardVisibilityUseCase();
    _deleteAgentUseCase = MockDeleteAgentUseCase();
    _requestActivateUseCase = MockRequestActivateUseCase();
    _requestDeactivateUseCase = MockRequestDeactivateUseCase();
    _requestLockUseCase = MockRequestLockUseCase();
    _requestPasswordResetUseCase = MockRequestPasswordResetUseCase();
    _filterAgentVisibileAccountsUseCase =
        MockFilterAgentVisibileAccountsUseCase();
    _filterAgentVisibileCardsUseCase = MockFilterAgentVisibileCardsUseCase();

    _successId = 'success';
    _failureId = 'failure';
    _emptyId = 'empty';
    _corporationId = 'corporationId';

    _corporation = Customer(
      id: _corporationId,
    );

    _agent = User(
      id: _successId,
      firstName: 'John',
    );
    _emptyAgent = User(
      id: _emptyId,
      firstName: 'Maria',
    );
    _exceptionAgent = User(
      id: _failureId,
      firstName: 'Carlos',
    );

    _acls = List.generate(
      5,
      (index) => AgentACL(
        accountId: index.toString(),
      ),
    );

    _cards = List.generate(
      5,
      (index) => BankingCard(
        cardId: index.toString(),
        preferences: CardPreferences(),
        status: CardStatus.active,
      ),
    );

    _accounts = List.generate(
      5,
      (index) => Account(
        id: index.toString(),
      ),
    );

    when(
      () => _customerAccountsUseCase(customerId: _corporationId),
    ).thenAnswer(
      (_) async => _accounts,
    );

    when(
      () => _customerAccountsUseCase(customerId: _failureId),
    ).thenThrow(
      Exception('Some error'),
    );

    when(
      () => _cardsUseCase(customerId: _corporationId),
    ).thenAnswer(
      (_) async => _cards,
    );

    when(
      () => _cardsUseCase(customerId: _failureId),
    ).thenThrow(
      Exception('Some error'),
    );

    when(
      () => _aclUseCase(
        userId: _successId,
        username: any(named: 'username'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => _acls,
    );

    when(
      () => _aclUseCase(
        userId: _emptyId,
        username: any(named: 'username'),
        status: any(named: 'status'),
      ),
    ).thenAnswer(
      (_) async => [],
    );

    when(
      () => _aclUseCase(
        userId: _failureId,
        username: any(named: 'username'),
        status: any(named: 'status'),
      ),
    ).thenThrow(
      Exception('Some error'),
    );

    when(
      () => _filterAgentVisibileAccountsUseCase(
        accounts: any(named: 'accounts'),
        acls: any(named: 'acls'),
      ),
    ).thenAnswer(
      (_) => _accounts,
    );

    when(
      () => _filterAgentVisibileCardsUseCase(
        cards: any(named: 'cards'),
        acls: any(named: 'acls'),
      ),
    ).thenAnswer(
      (_) => _cards,
    );
  });

  blocTest<AgentDetailsCubit, AgentDetailsState>(
    'Should start with empty state',
    build: create,
    verify: (c) => expect(
      c.state,
      AgentDetailsState(
        agent: _agent,
        corporation: _corporation,
        visibleAccountsList: [],
        corporationAccountsList: [],
        corporationCardsList: [],
        action: AgentDetailsAction.none,
        visibleCardsList: [],
        error: AgentDetailsError.none,
      ),
    ),
  );

  blocTest<AgentDetailsCubit, AgentDetailsState>(
    'Should emit empty lists when ACLs are empty',
    build: () => create(
      agent: _emptyAgent,
    ),
    act: (c) => c.load(),
    expect: () => [
      AgentDetailsState(
        agent: _emptyAgent,
        corporation: _corporation,
        visibleAccountsList: [],
        action: AgentDetailsAction.loadingACL,
        visibleCardsList: [],
        corporationAccountsList: [],
        corporationCardsList: [],
        error: AgentDetailsError.none,
      ),
      AgentDetailsState(
        agent: _emptyAgent,
        corporation: _corporation,
        visibleAccountsList: [],
        action: AgentDetailsAction.none,
        visibleCardsList: [],
        corporationAccountsList: _accounts,
        corporationCardsList: _cards,
        error: AgentDetailsError.none,
      ),
    ],
  );

  blocTest<AgentDetailsCubit, AgentDetailsState>(
    'Should emit the correct lists',
    build: create,
    act: (c) => c.load(),
    expect: () => [
      AgentDetailsState(
        agent: _agent,
        corporation: _corporation,
        visibleAccountsList: [],
        action: AgentDetailsAction.loadingACL,
        visibleCardsList: [],
        corporationAccountsList: [],
        corporationCardsList: [],
        error: AgentDetailsError.none,
      ),
      AgentDetailsState(
        agent: _agent,
        corporation: _corporation,
        visibleAccountsList: _accounts,
        action: AgentDetailsAction.none,
        visibleCardsList: _cards,
        corporationAccountsList: _accounts,
        corporationCardsList: _cards,
        error: AgentDetailsError.none,
      ),
    ],
  );

  blocTest<AgentDetailsCubit, AgentDetailsState>(
    'Should handle exceptions gracefully',
    build: () => create(
      agent: _exceptionAgent,
    ),
    act: (c) => c.load(),
    expect: () => [
      AgentDetailsState(
        agent: _exceptionAgent,
        corporation: _corporation,
        visibleAccountsList: [],
        action: AgentDetailsAction.loadingACL,
        visibleCardsList: [],
        corporationAccountsList: [],
        corporationCardsList: [],
        error: AgentDetailsError.none,
      ),
      AgentDetailsState(
        agent: _exceptionAgent,
        corporation: _corporation,
        visibleAccountsList: [],
        action: AgentDetailsAction.none,
        visibleCardsList: [],
        corporationAccountsList: [],
        corporationCardsList: [],
        error: AgentDetailsError.failedToLoadACL,
      ),
    ],
  );
}
