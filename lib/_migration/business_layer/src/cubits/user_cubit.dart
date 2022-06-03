import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'user_state.dart';

/// A cubit that manages the state of the [User]s.
class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  /// Creates the [UserCubit].
  UserCubit({
    required UserRepository repository,
    required String customerId,
  })  : _repository = repository,
        super(
          UserState(
            customerId: customerId,
          ),
        );

  /// Loads the [User] needed
  Future<void> loadUser({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({UserBusyAction.load}),
        error: UserStateError.none,
      ),
    );

    try {
      final user = await _repository.getUser(
        customerID: state.customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.load}),
          user: user,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({UserBusyAction.load}),
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

      await _repository.requestLock(
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

      await _repository.requestUnlock(
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

      await _repository.requestActivate(
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

      await _repository.requestDeactivate(
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

      await _repository.requestPasswordReset(
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

      await _repository.requestPINReset(
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
      final result = await _repository.patchUserRoles(
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
      final result = await _repository.patchUserBlockedChannels(
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
