import 'dart:collection';

import 'package:equatable/equatable.dart';

/// The available errors.
enum UserPreferencesError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// Represents all actions that can be performed by the user
enum UserPreferencesAction {
  /// No action performed
  none,

  /// A new favorite was removed
  favoriteRemoved,

  /// A new favorite was added
  favoriteAdded,

  /// A new low balance was added
  lowBalanceAdded,
}

///The state for the [UserPreferencesCubit]
class UserPreferencesState extends Equatable {
  /// The list of favorite offer ids.
  final UnmodifiableListView<int> favoriteOffers;

  /// Whether the cubit is processing something or not.
  final bool busy;

  /// The current error.
  final UserPreferencesError error;

  /// Holds the error message returned by the API.
  final String? errorMessage;

  /// The last action performed by the user.
  final UserPreferencesAction action;

  /// A new low balance was added
  final double? lowBalanceValue;

  ///Creates a new [UserPreferencesState]
  UserPreferencesState({
    Iterable<int> favoriteOffers = const <int>[],
    this.busy = false,
    this.error = UserPreferencesError.none,
    this.errorMessage,
    this.lowBalanceValue,
    this.action = UserPreferencesAction.none,
  }) : favoriteOffers = UnmodifiableListView(favoriteOffers);

  ///Copies this state with different values
  UserPreferencesState copyWith({
    Iterable<int>? favoriteOffers,
    double? lowBalanceValue,
    bool? busy,
    UserPreferencesError? error,
    String? errorMessage,
    UserPreferencesAction? action,
  }) =>
      UserPreferencesState(
        favoriteOffers: favoriteOffers ?? this.favoriteOffers,
        lowBalanceValue: lowBalanceValue ?? this.lowBalanceValue,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == UserPreferencesError.none
            ? null
            : (errorMessage ?? this.errorMessage),
        action: action ?? this.action,
      );

  @override
  List<Object?> get props => [
        favoriteOffers,
        busy,
        error,
        errorMessage,
        action,
        lowBalanceValue,
      ];
}
