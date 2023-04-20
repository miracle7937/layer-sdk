import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/user.dart';
import '../app.dart';
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
  Future<bool> showEnableBiometricsScreen({
    required BuildContext context,
    ValueChanged<bool>? onResult,
  }) async {
    final biometricsCubit = context.read<BiometricsCreator>().create();

    return await Navigator.push<bool>(
          context,
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (context, _, __) =>
                BlocProvider<BiometricsCubit>.value(
              value: biometricsCubit,
              child: Builder(
                builder: (context) => EnableBiometricsScreen(
                  onEnable: () => onResult != null
                      ? onResult(true)
                      : Navigator.pop(context, true),
                  onSkip: () => onResult != null
                      ? onResult(false)
                      : Navigator.pop(context, false),
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
  /// Provide the [accessPin] parameter for saving if the user has enabled the
  /// biometrics authentication. If the user opted out of biometrics do not
  /// provide the pin, as we should not be saving it.
  Future<void> persistsUser(
    BuildContext context, {
    required User user,
    required String ocraSecret,
    String accessPin = '',
  }) async {
    assert(ocraSecret.isNotEmpty, 'The ocra secret cannot be empty');

    final storageCubit = context.read<StorageCreator>().create();

    final alreadyLoggedIn = await _isUserLoggedIn(
      storageCubit,
      user,
    );
    if (alreadyLoggedIn) {
      return BottomSheetHelper.showError(
        context: context,
        titleKey: 'user_already_registered',
      );
    } else {
      await storageCubit.saveOcraSecretKey(ocraSecret);

      if (accessPin.isNotEmpty) {
        storageCubit.toggleBiometric(isBiometricsActive: true);
        await storageCubit.saveAccessPinForBiometrics(accessPin);
        await storageCubit.saveAuthenticationSettings(
          useBiometrics: true,
        );
      }

      await storageCubit.saveUser(
        user: user,
      );

      BankApp.restart(context);
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
