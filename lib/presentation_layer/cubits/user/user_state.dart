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

  /// Loading more users.
  loadMore,

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

  /// Requesting deleting the agent
  delete,
}

/// A state representing the user in the app.
class UserState extends Equatable {
  /// This field is null before the user is fetched.
  User? get user => users.isNotEmpty ? users[0] : null;

  /// List of [User]s. For corporate customer.
  final UnmodifiableListView<User> users;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// True if the cubit is processing something.
  /// This is calculated by what action is the cubit performing.
  final bool busy;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<UserBusyAction> actions;

  /// The last occurred error
  final UserStateError error;

  /// Has all the data needed to handle the list of users.
  final UserListData listData;

  /// Creates the [UserState].
  UserState({
    required this.customerId,
    Iterable<User> users = const [],
    Set<UserBusyAction> actions = const <UserBusyAction>{},
    this.error = UserStateError.none,
    UserListData? listData,
  })  : users = UnmodifiableListView(users),
        actions = UnmodifiableSetView(actions),
        busy = actions.isNotEmpty,
        listData = listData ?? UserListData();

  /// Creates a new instance of [UserState] based on this one.
  UserState copyWith({
    Iterable<User>? users,
    Set<UserBusyAction>? actions,
    String? customerId,
    UserStateError? error,
    UserListData? listData,
  }) {
    return UserState(
      users: users ?? this.users,
      actions: actions ?? this.actions,
      customerId: customerId ?? this.customerId,
      error: error ?? this.error,
      listData: listData ?? this.listData,
    );
  }

  @override
  List<Object?> get props => [
        users,
        busy,
        actions,
        customerId,
        error,
        listData,
      ];
}

/// Keeps all the data needed for filtering the user
class UserListData extends Equatable {
  /// The users offset for the loaded list.
  final int offset;

  /// The field to sort the data.
  final UserSort sortBy;

  /// If field should be sorted in descending order.
  final bool descendingOrder;

  /// Search string.
  final String? searchString;

  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// Creates a new [UserListData] with the default values.
  UserListData({
    this.sortBy = UserSort.registered,
    this.descendingOrder = true,
    this.searchString,
    this.offset = 0,
    this.canLoadMore = false,
  });

  @override
  List<Object?> get props => [
        sortBy,
        descendingOrder,
        searchString,
        offset,
        canLoadMore,
      ];

  /// Creates a new object based on this one.
  UserListData copyWith({
    UserSort? sortBy,
    bool? descendingOrder,
    String? searchString,
    int? offset,
    bool? canLoadMore,
  }) =>
      UserListData(
        sortBy: sortBy ?? this.sortBy,
        descendingOrder: descendingOrder ?? this.descendingOrder,
        searchString: searchString ?? this.searchString,
        offset: offset ?? this.offset,
        canLoadMore: canLoadMore ?? this.canLoadMore,
      );
}
