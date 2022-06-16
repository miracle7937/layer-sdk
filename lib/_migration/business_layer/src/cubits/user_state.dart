import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// All possible errors for [UserState]
enum UserStateError {
  /// No error
  none,

  /// Generic error
  generic,
}

/// Describe what the cubit may be busy performing.
enum UserBusyAction {
  /// Loading the user.
  load,

  /// Requesting lock.
  lock,

  /// Requesting unlock.
  unlock,

  /// Requesting activation.
  activate,

  /// Requesting deactivation.
  deactivate,

  /// Requesting password reset.
  passwordReset,

  /// Requesting PIN reset.
  pinReset,

  /// The user is being updated.
  patchingUser,

  /// The user blocked channels is being updated.
  patchingUserBlockedChannels,
}

/// A state representing the user in the app.
class UserState extends Equatable {
  /// This field is null before the user is fetched.
  final User? user;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// True if the cubit is processing something.
  /// This is calculated by what action is the cubit performing.
  final bool busy;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<UserBusyAction> actions;

  /// The last occurred error
  final UserStateError error;

  /// Creates the [UserState].
  UserState({
    required this.customerId,
    this.user,
    Set<UserBusyAction> actions = const <UserBusyAction>{},
    this.error = UserStateError.none,
  })  : actions = UnmodifiableSetView(actions),
        busy = actions.isNotEmpty;

  /// Creates a new instance of [UserState] based on this one.
  UserState copyWith({
    User? user,
    Set<UserBusyAction>? actions,
    String? customerId,
    UserStateError? error,
  }) {
    return UserState(
      user: user ?? this.user,
      actions: actions ?? this.actions,
      customerId: customerId ?? this.customerId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        user,
        busy,
        actions,
        customerId,
        error,
      ];
}
