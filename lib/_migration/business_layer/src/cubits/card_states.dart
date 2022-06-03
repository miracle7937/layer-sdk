import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// Represents the state of [CardCubit]
class CardState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// List of [BankingCard] of the customer
  final UnmodifiableListView<BankingCard> cards;

  /// Error message for the last occurred error
  final CardStateErrors error;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// Creates a new instance of [CardState]
  CardState({
    required this.customerId,
    Iterable<BankingCard> cards = const [],
    this.busy = false,
    this.error = CardStateErrors.none,
  }) : cards = UnmodifiableListView(cards);

  @override
  List<Object?> get props => [
        cards,
        busy,
        error,
        customerId,
      ];

  /// Creates a new instance of [CardState] based on the current instance
  CardState copyWith({
    bool? busy,
    Iterable<BankingCard>? cards,
    CardStateErrors? error,
    String? customerId,
  }) {
    return CardState(
      busy: busy ?? this.busy,
      cards: cards ?? this.cards,
      error: error ?? this.error,
      customerId: customerId ?? this.customerId,
    );
  }
}

/// Enum for all possible errors for [CardCubit]
enum CardStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}
