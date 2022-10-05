import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the actions that can be performed by [CardCubit]
enum CardDashboardAction {
  /// Loading the cards
  loadCards,

  /// Loading the financial data
  loadFinancialData,

  /// Loading the card info
  loadCardInfo,

  /// The second factor is being verified.
  verifySecondFactor,

  /// The second factor is being resent.
  resendSecondFactor,
}

/// The available events that the cubit can emit.
enum CardDashboardEvent {
  /// Event for inputting the second factor (biometrics/otp)
  inputSecondFactor,

  /// Event for closing the OTP code.
  closeOTPView,

  /// Event to show card info
  showCardInfo,
}

/// Represents the error codes that can be returned by [CardCubit]
enum CardDashboardValidationErrorCode {
  /// Network error
  network,

  /// Generic error
  generic
}

/// Represents the state of [CardCubit]
class CardDashboardState extends BaseState<CardDashboardAction,
    CardDashboardEvent, CardDashboardValidationErrorCode> {
  /// List of [BankingCard] of the customer
  final UnmodifiableListView<BankingCard> cards;

  /// Financial data of the customer
  final FinancialData? financialData;

  /// The card info for the last selected card
  final CardInfo? cardInfo;

  /// The otp id
  final int? otpId;

  /// Client response for ocra flow
  final String? clientResponse;

  /// Creates a new instance of [CardState]
  CardDashboardState({
    this.financialData,
    this.cardInfo,
    this.otpId,
    this.clientResponse,
    Iterable<BankingCard> cards = const [],
    super.actions = const <CardDashboardAction>{},
    super.events = const <CardDashboardEvent>{},
    super.errors = const <CubitError>{},
  }) : cards = UnmodifiableListView(cards);

  @override
  List<Object?> get props => [
        cards,
        actions,
        events,
        errors,
        financialData,
        cardInfo,
        otpId,
        clientResponse,
      ];

  /// Creates a new instance of [CardDashboardState] based
  /// on the current instance
  CardDashboardState copyWith({
    Iterable<BankingCard>? cards,
    Set<CardDashboardAction>? actions,
    Set<CardDashboardEvent>? events,
    Set<CubitError>? errors,
    FinancialData? financialData,
    CardInfo? cardInfo,
    int? otpId,
    String? clientResponse,
  }) {
    return CardDashboardState(
      financialData: financialData ?? this.financialData,
      cards: cards ?? this.cards,
      actions: actions ?? this.actions,
      events: events ?? super.events,
      errors: errors ?? this.errors,
      cardInfo: cardInfo ?? this.cardInfo,
      otpId: otpId ?? this.otpId,
      clientResponse: clientResponse ?? this.clientResponse,
    );
  }
}
