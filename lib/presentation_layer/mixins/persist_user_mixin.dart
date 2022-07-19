import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/user.dart';
import '../creators.dart';
import '../cubits.dart';
import '../widgets.dart';

/// A mixin that exposes a method for persisting the returned user from a
/// register / login flow.
mixin PersistUserMixin {
  /// Persist the passed [user].
  ///
  /// The [pin] is required in order to persist the user.
  ///
  /// Use the [useBiometrics] parameter for indicating if the user enabled
  /// the biometrics or not.
  Future<void> persistsUser(
    BuildContext context, {
    required User user,
    required String pin,
    bool useBiometrics = false,
  }) async {
    assert(pin.isNotEmpty, 'The pin cannot be empty');

    final storageCubit = context.read<StorageCreator>().create();

    final alreadyLoggedIn = await _isUserLoggedIn(
      storageCubit,
      user,
    );
    if (alreadyLoggedIn) {
      BottomSheetHelper.showError(
        context: context,
        titleKey: 'user_already_registered',
      );
    } else {
      await storageCubit.saveUser(user: user);
    }
  }

  /// Returns whether if the user is already logged in or not.
  Future<bool> _isUserLoggedIn(
    StorageCubit storageCubit,
    User user,
  ) async {
    await storageCubit.loadLoggedInUsers();

    return storageCubit.state.loggedInUsers
                .singleWhereOrNull((loggedUser) => loggedUser.id == user.id) ==
            null
        ? false
        : true;
  }
}
