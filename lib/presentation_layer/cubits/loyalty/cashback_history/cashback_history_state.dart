import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// The available errors.
enum CashbackHistoryStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// The state of the [CashbackHistoryCubit].
class CashbackHistoryState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The cashback history.
  final CashbackHistory? cashbackHistory;

  /// Holds the current error
  final CashbackHistoryStateError error;

  /// The error message.
  final String? errorMessage;

  /// Creates [CashbackHistoryState].
  CashbackHistoryState({
    this.busy = false,
    this.cashbackHistory,
    this.error = CashbackHistoryStateError.none,
    this.errorMessage,
  });

  /// Creates a new state based on this one.
  CashbackHistoryState copyWith({
    bool? busy,
    CashbackHistory? cashbackHistory,
    CashbackHistoryStateError? error,
    String? errorMessage,
  }) =>
      CashbackHistoryState(
        busy: busy ?? this.busy,
        cashbackHistory: cashbackHistory ?? this.cashbackHistory,
        error: error ?? this.error,
        errorMessage: error == CashbackHistoryStateError.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        busy,
        cashbackHistory,
        error,
        errorMessage,
      ];
}
