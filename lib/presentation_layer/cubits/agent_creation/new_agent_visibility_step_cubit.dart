import 'dart:async';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit responsible for visibility step of Agent's creation process.
class NewAgentVisibilityStepCubit
    extends StepCubit<NewAgentVisibilityStepState> {
  final LoadAgentACLUseCase _loadAclUseCase;
  final GetCustomerAccountsUseCase _loadAccountsUseCase;
  final LoadCustomerCardsUseCase _loadCardsUseCase;

  @override
  User get user => User(
        id: '',
        visibleCards: state.visibleCards,
        visibleAccounts: state.visibleAccounts,
      );

  /// Creates new [NewAgentVisibilityStepCubit].
  NewAgentVisibilityStepCubit({
    required LoadAgentACLUseCase loadAgentACLUseCase,
    required GetCustomerAccountsUseCase loadAccountsUseCase,
    required LoadCustomerCardsUseCase loadCardsUseCase,
    required String corporationId,
    User? user,
  })  : _loadAclUseCase = loadAgentACLUseCase,
        _loadAccountsUseCase = loadAccountsUseCase,
        _loadCardsUseCase = loadCardsUseCase,
        super(
          NewAgentVisibilityStepState(
            corporationId: corporationId,
          ),
          user: user,
        );

  /// Loads the available accounts and cards.
  ///
  /// If the cubit is in edit mode, loads their visibility too.
  Future<void> load() async {
    emit(state.copyWith(
      busy: true,
      error: NewAgentVisibilityStepError.none,
    ));

    try {
      final futures = await Future.wait([
        _loadAccountsUseCase(customerId: state.corporationId),
        _loadCardsUseCase(customerId: state.corporationId),
        if (isEdit)
          _loadAclUseCase(
            userId: super.user!.id,
            username: super.user!.username ?? '',
            status: 'A',
          ),
      ]);

      final accounts = futures[0] as List<Account>;
      final cards = futures[1] as List<BankingCard>;
      var visibleCards = const <BankingCard>[];
      var visibleAccounts = const <Account>[];
      if (isEdit) {
        final acl = futures[2] as List<AgentACL>;
        visibleCards = cards
            .where(
              (card) => acl.any(
                (element) => element.cardId == card.cardId,
              ),
            )
            .toList();
        visibleAccounts = accounts
            .where(
              (account) => acl.any(
                (element) => element.accountId == account.id,
              ),
            )
            .toList();
      }

      emit(state.copyWith(
        busy: false,
        accounts: accounts,
        cards: cards,
        visibleAccounts: isEdit ? visibleAccounts : state.visibleAccounts,
        visibleCards: isEdit ? visibleCards : state.visibleCards,
      ));
    } on Exception {
      emit(state.copyWith(
        busy: false,
        error: NewAgentVisibilityStepError.generic,
      ));
    }
  }

  /// Handles event of selecting the [BankingCard]
  void onCardTap(BankingCard card) => emit(state.copyWith(
        visibleCards: state.visibleCards.contains(card)
            ? (state.visibleCards.toList()..remove(card))
            : (state.visibleCards.toList()..add(card)),
        action: StepsStateAction.editAction,
      ));

  /// Handles event of selecting the [Account]
  void onAccountTap(Account account) => emit(state.copyWith(
        visibleAccounts: state.visibleAccounts.contains(account)
            ? (state.visibleAccounts.toList()..remove(account))
            : (state.visibleAccounts.toList()..add(account)),
        action: StepsStateAction.editAction,
      ));

  @override
  Future<bool> onContinue() => Future.value(true);
}
