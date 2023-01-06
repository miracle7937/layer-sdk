import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The new agent visibility step errors
enum NewAgentVisibilityStepError {
  /// There is no error in the state.
  none,

  /// A generic error has occurred.
  generic,
}

/// The state of the [NewAgentVisibilityStepCubit]
class NewAgentVisibilityStepState extends NewAgentStepState {
  /// The id of the corporation that the agent belongs to.
  final String corporationId;

  /// List of all available [BankingCard]s
  final UnmodifiableListView<BankingCard> cards;

  /// List of all selected [BankingCard]s
  final UnmodifiableListView<BankingCard> visibleCards;

  /// List of all available [Account]s
  final UnmodifiableListView<Account> accounts;

  /// List of all visible [Account]s
  final UnmodifiableListView<Account> visibleAccounts;

  /// The current error.
  final NewAgentVisibilityStepError error;

  /// Creates [NewAgentVisibilityStepState].
  NewAgentVisibilityStepState({
    required this.corporationId,
    Iterable<BankingCard> cards = const [],
    Iterable<BankingCard> visibleCards = const [],
    Iterable<Account> accounts = const [],
    Iterable<Account> visibleAccounts = const [],
    StepsStateAction action = StepsStateAction.none,
    bool filled = false,
    bool busy = false,
    this.error = NewAgentVisibilityStepError.none,
  })  : cards = UnmodifiableListView(cards),
        visibleCards = UnmodifiableListView(visibleCards),
        accounts = UnmodifiableListView(accounts),
        visibleAccounts = UnmodifiableListView(visibleAccounts),
        super(
          action: action,
          completed: filled,
          busy: busy,
        );

  /// Creates a new state based on this one.
  @override
  NewAgentVisibilityStepState copyWith({
    String? corporationId,
    Iterable<BankingCard>? cards,
    Iterable<BankingCard>? visibleCards,
    Iterable<Account>? accounts,
    Iterable<Account>? visibleAccounts,
    StepsStateAction? action,
    bool? completed,
    bool? busy,
    NewAgentVisibilityStepError? error,
  }) =>
      NewAgentVisibilityStepState(
        corporationId: corporationId ?? this.corporationId,
        cards: cards ?? this.cards,
        visibleCards: visibleCards ?? this.visibleCards,
        accounts: accounts ?? this.accounts,
        visibleAccounts: visibleAccounts ?? this.visibleAccounts,
        action: action ?? this.action,
        filled: completed ?? this.completed,
        busy: busy ?? this.busy,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        corporationId,
        action,
        completed,
        busy,
        cards,
        visibleCards,
        accounts,
        visibleAccounts,
        error,
      ];
}
