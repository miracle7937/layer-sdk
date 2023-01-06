import 'package:bloc/bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that manages the state of the [User]s.
class UserCubit extends Cubit<UserState> {
  final LoadUsersByCustomerIdUseCase _loadUsersByCustomerIdUseCase;
  final RequestLockUseCase _requestLockUseCase;
  final RequestUnlockUseCase _requestUnlockUseCase;
  final RequestActivateUseCase _requestActivateUseCase;
  final RequestDeactivateUseCase _requestDeactivateUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final RequestPINResetUseCase _requestPINResetUseCase;
  final PatchUserRolesUseCase _patchUserRolesUseCase;
  final DeleteAgentUseCase _deleteUseCase;
  final PatchUserBlockedChannelUseCase _patchUserBlockedChannelUseCase;

  /// Maximum number of users to load at a time.
  final int limit;

  /// Creates the [UserCubit].
  UserCubit({
    required String customerId,
    required LoadUsersByCustomerIdUseCase loadUserByCustomerIdUseCase,
    required RequestLockUseCase requestLockUseCase,
    required RequestUnlockUseCase requestUnlockUseCase,
    required RequestActivateUseCase requestActivateUseCase,
    required RequestDeactivateUseCase requestDeactivateUseCase,
    required RequestPasswordResetUseCase requestPasswordResetUseCase,
    required RequestPINResetUseCase requestPINResetUseCase,
    required PatchUserRolesUseCase patchUserRolesUseCase,
    required DeleteAgentUseCase deleteAgentUseCase,
    required PatchUserBlockedChannelUseCase patchUserBlockedChannelUseCase,
    this.limit = 50,
  })  : _loadUsersByCustomerIdUseCase = loadUserByCustomerIdUseCase,
        _requestLockUseCase = requestLockUseCase,
        _requestUnlockUseCase = requestUnlockUseCase,
        _requestActivateUseCase = requestActivateUseCase,
        _requestDeactivateUseCase = requestDeactivateUseCase,
        _requestPasswordResetUseCase = requestPasswordResetUseCase,
        _requestPINResetUseCase = requestPINResetUseCase,
        _patchUserRolesUseCase = patchUserRolesUseCase,
        _deleteUseCase = deleteAgentUseCase,
        _patchUserBlockedChannelUseCase = patchUserBlockedChannelUseCase,
        super(
          UserState(
            customerId: customerId,
          ),
        );

  /// Loads the [User]s needed
  Future<void> load({
    String searchString = '',
    UserSort sortBy = UserSort.registered,
    bool descendingOrder = true,
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({
          loadMore ? UserBusyAction.loadMore : UserBusyAction.load,
        }),
        error: UserStateError.none,
      ),
    );

    final offset = loadMore ? state.listData.offset + limit : 0;

    try {
      final users = await _loadUsersByCustomerIdUseCase(
        customerID: state.customerId,
        name: searchString,
        forceRefresh: forceRefresh,
        offset: offset,
        limit: limit,
        descendingOrder: descendingOrder,
      );

      final list = offset > 0
          ? [
              ...state.users.take(offset).toList(),
              ...users,
            ]
          : users;

      emit(
        state.copyWith(
          users: list,
          actions: state.actions.difference({
            UserBusyAction.load,
            UserBusyAction.loadMore,
          }),
          listData: state.listData.copyWith(
            canLoadMore: users.length >= limit,
            searchString: searchString,
            offset: offset,
            sortBy: sortBy,
            descendingOrder: descendingOrder,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            UserBusyAction.load,
            UserBusyAction.loadMore,
          }),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request a lock of this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestLock({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.lock}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _requestLockUseCase(
        userId: state.user!.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.lock}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.lock}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request an unlock of this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestUnlock({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.unlock}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _requestUnlockUseCase(
        userId: state.user!.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.unlock}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.unlock}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request activation of this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestActivate({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.activate}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _requestActivateUseCase(
        userId: state.user!.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.activate}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.activate}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request deactivation of this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestDeactivate({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.deactivate}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _requestDeactivateUseCase(
        userId: state.user!.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.deactivate}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.deactivate}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request a password change for this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestPasswordReset({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.passwordReset}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _requestPasswordResetUseCase(
        userId: state.user!.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.passwordReset}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.passwordReset}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request a PIN change for this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> requestPINReset({
    required CustomerType customerType,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.pinReset}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _requestPINResetUseCase(
        userId: state.user!.id,
        customerType: customerType,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.pinReset}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.pinReset}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Updates the current user roles.
  ///
  /// Used by the console (DBO) app only.
  Future<void> patchUserRoles({
    required List<String> roles,
  }) async {
    assert(state.user != null);

    emit(
      state.copyWith(
        actions: state.actions.union({
          UserBusyAction.patchingUser,
        }),
        error: UserStateError.none,
      ),
    );

    try {
      final result = await _patchUserRolesUseCase(
        userId: state.user!.id,
        roles: roles,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({
            UserBusyAction.patchingUser,
          }),
          error: result ? null : UserStateError.generic,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            UserBusyAction.patchingUser,
          }),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Request a Delete agent for this user.
  ///
  /// Used by the console (DBO) app only.
  Future<void> delete() async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.delete}),
        error: UserStateError.none,
      ),
    );

    try {
      if (state.user == null) throw Exception('No user loaded.');

      await _deleteUseCase(
        user: state.user!,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.delete}),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.delete}),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Updates the current user blocked channels.
  ///
  /// Used by the console (DBO) app only.
  Future<void> patchUserBlockedChannels({
    required List<String> channels,
  }) async {
    assert(state.user != null);

    emit(
      state.copyWith(
        actions: state.actions.union({
          UserBusyAction.patchingUserBlockedChannels,
        }),
        error: UserStateError.none,
      ),
    );

    try {
      final result = await _patchUserBlockedChannelUseCase(
        userId: state.user!.id,
        channels: channels,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({
            UserBusyAction.patchingUserBlockedChannels,
          }),
          error: result ? null : UserStateError.generic,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            UserBusyAction.patchingUserBlockedChannels,
          }),
          error: UserStateError.generic,
        ),
      );

      rethrow;
    }
  }
}
