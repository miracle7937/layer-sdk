import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import '../../../domain_layer/models.dart';

/// Represents all actions that can be performed by the cubit.
enum AgentDetailsAction {
  /// No action being performed.
  none,

  /// Loading the Access Control List of the agent.
  loadingACL,

  /// Updating the Accounts Access Control List of the agent.
  updatingAccountACL,

  /// Updating the Cards Access Control List of the agent.
  updatingCardACL,

  /// The agent is being deleted.
  deleteAgent,

  /// Requesting a password reset for the agent.
  passwordReset,

  /// Deactivating the  agent.
  deactivateAgent,

  /// Locking the agent.
  lockAgent,
}

/// Represents all errors that can be emitted by the cubit.
enum AgentDetailsError {
  /// No error emitted.
  none,

  /// Failed to load the agent AccessControlList.
  failedToLoadACL,

  /// Failed to update the accounts Access Control List of the agent.
  failedToUpdateAccountACL,

  /// Failed to update the cards Access Control List of the agent.
  failedToUpdateCardACL,

  /// Failed to delete the agent.
  failedToDeleteAgent,

  /// Password reset request failed.
  failedToResetPassword,

  /// Agent deactivation request failed.
  failedToDeactivateAgent,

  /// Failed to lock the agent.
  failedToLockAgent,
}

/// Holds the state of the [AgentDetailsCubit].
class AgentDetailsState extends Equatable {
  /// The list of accounts the agent is able to see.
  final UnmodifiableListView<Account> visibleAccounts;

  /// The list of accounts that belongs to the corporation of this agent.
  final UnmodifiableListView<Account> corporationAccounts;

  /// The list of cards the agent is able to see.
  final UnmodifiableListView<BankingCard> visibleCards;

  /// The list of cards that belongs to the corporation of this agent.
  final UnmodifiableListView<BankingCard> corporationCards;

  /// The action being performed by the cubit.
  final AgentDetailsAction action;

  /// The latest error emitted by the cubit.
  final AgentDetailsError error;

  /// The Corporation of the agent.
  final Customer corporation;

  /// The agent being used by this cubit.
  final User agent;

  /// Creates a new [AgentDetailsState] instance.
  AgentDetailsState({
    required this.agent,
    required this.corporation,
    Iterable<Account> visibleAccountsList = const [],
    Iterable<Account> corporationAccountsList = const [],
    Iterable<BankingCard> visibleCardsList = const [],
    Iterable<BankingCard> corporationCardsList = const [],
    this.action = AgentDetailsAction.none,
    this.error = AgentDetailsError.none,
  })  : visibleAccounts = UnmodifiableListView(visibleAccountsList),
        corporationAccounts = UnmodifiableListView(corporationAccountsList),
        visibleCards = UnmodifiableListView(visibleCardsList),
        corporationCards = UnmodifiableListView(corporationCardsList);

  /// Creates a copy of [AgentDetailsState] using the provided parameters.
  AgentDetailsState copyWith({
    Iterable<Account>? visibleAccounts,
    Iterable<Account>? corporationAccounts,
    Iterable<BankingCard>? visibleCards,
    Iterable<BankingCard>? corporationCards,
    AgentDetailsAction? action,
    AgentDetailsError? error,
  }) {
    return AgentDetailsState(
      agent: agent,
      corporation: corporation,
      visibleAccountsList: visibleAccounts ?? this.visibleAccounts,
      corporationAccountsList: corporationAccounts ?? this.corporationAccounts,
      visibleCardsList: visibleCards ?? this.visibleCards,
      corporationCardsList: corporationCards ?? this.corporationCards,
      action: action ?? this.action,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        agent,
        visibleAccounts,
        corporationAccounts,
        visibleCards,
        corporationCards,
        action,
        error,
        corporation,
      ];
}
