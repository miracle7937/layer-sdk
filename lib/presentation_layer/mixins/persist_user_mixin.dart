import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/user.dart';
import '../creators.dart';
import '../cubits.dart';
import '../features/enable_biometrics_screen/enable_biometrics_screen.dart';
import '../widgets.dart';

/// A mixin that exposes a method for persisting the returned user from a
/// register / login flow.
mixin PersistUserMixin {
  /// Shows the default enable biometrics screen.
  ///
  /// Returns a boolean value indicating whether if the user enabled the
  /// biometrics or not.
  Future<bool> showEnableBiometricsScreen(
    BuildContext context,
  ) async {
    final biometricsCubit = context.read<BiometricsCreator>().create();

    await biometricsCubit.initialize();

    if (!(biometricsCubit.state.canUseBiometrics ?? false)) {
      return false;
    }

    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<BiometricsCubit>.value(
              value: biometricsCubit,
              child: Builder(
                builder: (context) => EnableBiometricsScreen(
                  onEnable: () => Navigator.pop(context, true),
                  onSkip: () => Navigator.pop(context, false),
                ),
              ),
            ),
          ),
        ) ??
        false;
  }

  /// Persist the passed [user].
  ///
  /// The [pin] is required in order to persist the user.
  ///
  /// If the [ocraSecret] parameter is indicated, the user will authenticate
  /// using the ocra flow.
  ///
  /// Use the [useBiometrics] parameter for indicating if the user enabled
  /// the biometrics or not.
  Future<void> persistsUser(
    BuildContext context, {
    required User user,
    required String pin,
    String? ocraSecret,
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
      if (ocraSecret != null) {
        await storageCubit.saveOcraSecretKey(ocraSecret);
      }

      storageCubit.toggleBiometric(isBiometricsActive: useBiometrics);

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
