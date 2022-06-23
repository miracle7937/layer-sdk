import 'package:equatable/equatable.dart';

/// The available errors.
enum UnreadAlertsCountError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

///The state of the unread alerts count cubit
class UnreadAlertsCountState extends Equatable {
  /// The unread alerts count.
  final int count;

  /// If the cubit is processing something.
  final bool busy;

  /// The current error.
  final UnreadAlertsCountError error;

  /// Holds the error message returned by the API.
  final String? errorMessage;

  ///Creates a new [UnreadAlertsCountState]
  UnreadAlertsCountState({
    this.count = 0,
    this.busy = false,
    this.error = UnreadAlertsCountError.none,
    this.errorMessage,
  });

  ///Copies the object with new values
  UnreadAlertsCountState copyWith({
    int? count,
    bool? busy,
    UnreadAlertsCountError? error,
    String? errorMessage,
  }) =>
      UnreadAlertsCountState(
        count: count ?? this.count,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == UnreadAlertsCountError.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        count,
        busy,
        error,
        errorMessage,
      ];
}
