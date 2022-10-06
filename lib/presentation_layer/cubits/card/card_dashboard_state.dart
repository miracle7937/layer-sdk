import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the actions that can be performed by [CardDashboardCubit]
enum CardDashboardAction {
  /// Loading the cards
  loadCards,

  /// Loading the financial data
  loadFinancialData,
}

/// Represents the error codes that can be returned by [CardDashboardCubit]
enum CardDashboardValidationErrorCode {
  /// Network error
  network,

  /// Generic error
  generic
}

/// Represents the state of [CardDashboardCubit]
class CardDashboardState extends BaseState<CardDashboardAction, void,
    CardDashboardValidationErrorCode> {
  /// List of [BankingCard] of the customer
  final UnmodifiableListView<BankingCard> cards;

  /// Financial data of the customer
  final FinancialData? financialData;

  /// Creates a new instance of [CardState]
  CardDashboardState({
    this.financialData,
    Iterable<BankingCard> cards = const [],
    super.actions = const <CardDashboardAction>{},
    super.events = const <void>{},
    super.errors = const <CubitError>{},
  }) : cards = UnmodifiableListView(cards);

  @override
  List<Object?> get props => [
        cards,
        actions,
        events,
        errors,
        financialData,
      ];

  /// Creates a new instance of [CardDashboardState] based
  /// on the current instance
  CardDashboardState copyWith({
    Iterable<BankingCard>? cards,
    Set<CardDashboardAction>? actions,
    Set<CubitError>? errors,
    FinancialData? financialData,
  }) {
    return CardDashboardState(
      financialData: financialData ?? this.financialData,
      cards: cards ?? this.cards,
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
    );
  }
}
