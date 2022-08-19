import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../creators.dart';
import '../../cubits.dart';
import '../../extensions/ocra_authentication/ocra_authentication_error_ui_extension.dart';
import '../../features.dart';
import '../../utils.dart';
import '../../widgets.dart';

/// A screen that allows the user to set an access pin.
class LockScreen extends StatelessWidget {
  /// The pin length.
  /// Default is 6.
  final int pinLength;

  /// The title to show on the lock screen.
  final String title;

  /// Callback when the user has been authenticated successfully.
  final VoidCallback onAuthenticated;

  /// Whether if the biometrics should be used or not.
  /// Default is `false`.
  final bool useBiometrics;

  /// The ocra secret.
  final String ocraSecret;

  /// The device id.
  final int deviceId;

  /// Creates a new [LockScreen].
  LockScreen({
    Key? key,
    this.pinLength = 6,
    required this.title,
    required this.onAuthenticated,
    this.useBiometrics = false,
    required this.ocraSecret,
    required this.deviceId,
  }) : assert(ocraSecret.isNotEmpty, 'The ocra secret cannot be empty');

  @override
  Widget build(BuildContext context) => BlocProvider<OcraAuthenticationCubit>(
        create: (context) => context.read<OcraAuthenticationCreator>().create(
              ocraSecret: ocraSecret,
              deviceId: deviceId,
            ),
        child: Builder(
          builder: (context) => _LockScreen(
            key: key,
            pinLength: pinLength,
            title: title,
            onAuthenticated: onAuthenticated,
            useBiometrics: useBiometrics,
            ocraSecret: ocraSecret,
            deviceId: deviceId,
          ),
        ),
      );
}

/// A screen that allows the user to set an access pin.
class _LockScreen extends SetAccessPinBaseWidget {
  /// The title to show on the lock screen.
  final String title;

  /// Callback when the user has been authenticated successfully.
  final VoidCallback onAuthenticated;

  /// Whether if the biometrics should be used or not.
  /// Default is `false`.
  final bool useBiometrics;

  /// The ocra secret.
  final String ocraSecret;

  /// The device id.
  final int deviceId;

  /// Creates a new [_LockScreen].
  const _LockScreen({
    super.key,
    super.pinLength = 6,
    required this.title,
    required this.onAuthenticated,
    this.useBiometrics = false,
    required this.ocraSecret,
    required this.deviceId,
  });

  @override
  State<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends SetAccessPinBaseWidgetState<_LockScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.useBiometrics) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final biometricsCubit = context.read<BiometricsCreator>().create();
        await biometricsCubit.authenticate(
          localizedReason: Translation.of(context).translate(
            'biometric_dialog_description',
          ),
        );

        if (biometricsCubit.state.authenticated ?? false) {
          _onBiometrics();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);
    final translation = Translation.of(context);

    final state = context.watch<OcraAuthenticationCubit>().state;
    final error = state.error;

    return MultiBlocListener(
      listeners: [
        BlocListener<OcraAuthenticationCubit, OcraAuthenticationState>(
          listenWhen: (previous, current) =>
              previous.token != current.token && current.token != null,
          listener: (context, state) async {
            final storageCubit = context.read<StorageCreator>().create();
            await storageCubit.loadLastLoggedUser();

            final user = storageCubit.state.currentUser;

            if (user != null) {
              final authenticationCubit = context.read<AuthenticationCubit>();
              authenticationCubit.setLoggedUser(
                user.copyWith(
                  token: state.token,
                ),
              );

              authenticationCubit.setPinNeedsVerification(
                verified: true,
              );

              widget.onAuthenticated();
            }
          },
        ),
        BlocListener<OcraAuthenticationCubit, OcraAuthenticationState>(
          listenWhen: (previous, current) =>
              previous.error != current.error &&
              current.error != OcraAuthenticationError.none,
          listener: (context, state) => currentPin = '',
        ),
      ],
      child: Scaffold(
        backgroundColor: layerDesign.surfaceOctonary1,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: PinPadView(
              pinLenght: widget.pinLength,
              pin: currentPin,
              title: widget.title,
              disabled: disabled,
              warning: error.localize(
                translation,
                state.remainingAttempts,
              ),
              onChanged: (pin) async {
                currentPin = pin;
                if (pin.length == widget.pinLength) {
                  final authenticationCubit =
                      context.read<AuthenticationCubit>();
                  await context.read<OcraAuthenticationCubit>().generateToken(
                        password: currentPin,
                      );
                  await authenticationCubit.verifyAccessPin(pin);
                }
              },
              showBiometrics: widget.useBiometrics,
              onBiometrics: _onBiometrics,
            ),
          ),
        ),
      ),
    );
  }

  /// Method called when the user has completed the biometric authentication
  /// successfully.
  Future<void> _onBiometrics() async {
    final storageCubit = context.read<StorageCreator>().create();
    await storageCubit.loadLastLoggedUser();

    currentPin = storageCubit.state.currentUser?.accessPin ?? '';

    context.read<OcraAuthenticationCubit>().generateToken(
          password: storageCubit.state.currentUser?.accessPin,
        );
  }
}
