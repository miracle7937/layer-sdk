import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit that handles the data an Agent is able to view.
class AgentDetailsCubit extends Cubit<AgentDetailsState> {
  final GetCustomerAccountsUseCase _loadAccountsUseCase;
  final LoadCustomerCardsUseCase _loadCardsUseCase;
  final LoadAgentACLUseCase _loadAclUseCase;
  final RequestDeactivateUseCase _requestDeactivateUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final DeleteAgentUseCase _deleteUseCase;
  final UpdateAgentAccountVisibilityUseCase _updateAccountVisibilityUseCase;
  final UpdateAgentCardVisibilityUseCase _updateCardVisibilityUseCase;
  final RequestLockUseCase _lockUseCase;
  final FilterAgentVisibleAccountsUseCase _filterAgentVisibleAccountsUseCase;
  final FilterAgentVisibleCardsUseCase _filterAgentVisibleCardsUseCase;

  /// Creates a new [AgentDetailsCubit] instance.
  AgentDetailsCubit({
    required Customer corporation,
    required User agent,
    required GetCustomerAccountsUseCase accountsUseCase,
    required LoadCustomerCardsUseCase cardsUseCase,
    required LoadAgentACLUseCase aclUseCase,
    required UpdateAgentAccountVisibilityUseCase updateAccountVisibilityUseCase,
    required UpdateAgentCardVisibilityUseCase updateCardVisibilityUseCase,
    required RequestLockUseCase requestLockUseCase,
    required RequestActivateUseCase requestActivateUseCase,
    required RequestDeactivateUseCase requestDeactivateUseCase,
    required RequestPasswordResetUseCase requestPasswordResetUseCase,
    required DeleteAgentUseCase deleteAgentUseCase,
    required FilterAgentVisibleAccountsUseCase
        filterAgentVisibleAccountsUseCase,
    required FilterAgentVisibleCardsUseCase filterAgentVisibleCardsUseCase,
  })  : _loadAccountsUseCase = accountsUseCase,
        _loadCardsUseCase = cardsUseCase,
        _loadAclUseCase = aclUseCase,
        _requestDeactivateUseCase = requestDeactivateUseCase,
        _requestPasswordResetUseCase = requestPasswordResetUseCase,
        _deleteUseCase = deleteAgentUseCase,
        _updateAccountVisibilityUseCase = updateAccountVisibilityUseCase,
        _updateCardVisibilityUseCase = updateCardVisibilityUseCase,
        _lockUseCase = requestLockUseCase,
        _filterAgentVisibleAccountsUseCase = filterAgentVisibleAccountsUseCase,
        _filterAgentVisibleCardsUseCase = filterAgentVisibleCardsUseCase,
        super(
          AgentDetailsState(
            corporation: corporation,
            agent: agent,
          ),
        );

  /// Loads the accounts and cards that this agent is able to view.
  ///
  /// Use the `status` param to filter the Access Control List by its status
  /// Defaults to `Active (A)`.
  Future<void> load({
    String status = 'A',
  }) async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.loadingACL,
        error: AgentDetailsError.none,
      ),
    );

    try {
      final futures = await Future.wait([
        _loadAclUseCase(
          userId: state.agent.id,
          username: state.agent.username ?? '',
          status: status,
        ),
        _loadAccountsUseCase(customerId: state.corporation.id),
        _loadCardsUseCase(customerId: state.corporation.id),
      ]);

      final acls = futures[0] as List<AgentACL>;
      final accounts = futures[1] as List<Account>;
      final cards = futures[2] as List<BankingCard>;

      if (acls.isEmpty) {
        emit(
          state.copyWith(
            action: AgentDetailsAction.none,
            visibleAccounts: [],
            visibleCards: [],
            corporationAccounts: accounts,
            corporationCards: cards,
          ),
        );
        return;
      }

      final accountAcls = acls.where((e) => e.accountId.isNotEmpty).toList();
      final cardsAcls = acls.where((e) => e.cardId.isNotEmpty).toList();

      final visibleAccounts = _filterAgentVisibleAccountsUseCase(
        acls: accountAcls,
        accounts: accounts,
      );

      final visibleCards = _filterAgentVisibleCardsUseCase(
        acls: cardsAcls,
        cards: cards,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          visibleAccounts: visibleAccounts,
          visibleCards: visibleCards,
          corporationAccounts: accounts,
          corporationCards: cards,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToLoadACL,
        ),
      );
    }
  }

  /// Updates the `Access Control List` accounts with the provided accounts.
  Future<void> updateAccountVisibility({
    required List<Account> accounts,
  }) async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.updatingAccountACL,
        error: AgentDetailsError.none,
      ),
    );

    try {
      final result = await _updateAccountVisibilityUseCase(
        accounts: accounts,
        agent: state.agent,
        corporation: state.corporation,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: !result
              ? AgentDetailsError.failedToUpdateAccountACL
              : AgentDetailsError.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToUpdateAccountACL,
        ),
      );
    }
  }

  /// Updates the `Access Control List` cards with the provided cards.
  Future<void> updateCardVisibility({
    required List<BankingCard> cards,
  }) async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.updatingCardACL,
        error: AgentDetailsError.none,
      ),
    );

    try {
      final result = await _updateCardVisibilityUseCase(
        cards: cards,
        agent: state.agent,
        corporation: state.corporation,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: !result
              ? AgentDetailsError.failedToUpdateCardACL
              : AgentDetailsError.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToUpdateCardACL,
        ),
      );
    }
  }

  /// Request a Delete agent for this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> delete() async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.deleteAgent,
        error: AgentDetailsError.none,
      ),
    );

    try {
      await _deleteUseCase(
        user: state.agent,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToDeleteAgent,
        ),
      );
    }
  }

  /// Request the agent to be locked.
  ///
  /// Used by the console (DBO) app only.
  Future<void> lockAgent() async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.lockAgent,
        error: AgentDetailsError.none,
      ),
    );

    try {
      await _lockUseCase(
        customerType: CustomerType.corporate,
        userId: state.agent.id,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToLockAgent,
        ),
      );
    }
  }

  /// Request deactivation of this agent.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestDeactivate({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.deactivateAgent,
        error: AgentDetailsError.none,
      ),
    );

    try {
      await _requestDeactivateUseCase(
        userId: state.agent.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToDeactivateAgent,
        ),
      );
    }
  }

  /// Request a password change for this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestPasswordReset({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        action: AgentDetailsAction.passwordReset,
        error: AgentDetailsError.none,
      ),
    );

    try {
      await _requestPasswordResetUseCase(
        userId: state.agent.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          action: AgentDetailsAction.none,
          error: AgentDetailsError.failedToResetPassword,
        ),
      );
    }
  }
}
