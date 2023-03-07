import 'dart:io';
import 'dart:ui';

import 'package:carrier_info/carrier_info.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models/device_session/device_session.dart';
import '../../../domain_layer/models/resolution/resolution.dart';
import '../../../layer_sdk.dart';
import '../../cubits.dart';
import '../../extensions/ocra_authentication/ocra_authentication_error_ui_extension.dart';

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

  /// Whether to scramble the pin code or not
  final bool scramblePin;

  /// The Firebase notification token
  final String? notificationToken;

  /// Extra widget like contact us button
  final Widget? extraChild;

  /// Creates a new [LockScreen].
  LockScreen({
    Key? key,
    this.pinLength = 6,
    required this.title,
    required this.onAuthenticated,
    this.useBiometrics = false,
    required this.ocraSecret,
    required this.deviceId,
    this.scramblePin = false,
    this.notificationToken,
    this.extraChild,
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
            scramblePin: scramblePin,
            notifcationToken: notificationToken,
            extraChild: extraChild,
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
  ///
  /// Default is `false`.
  final bool useBiometrics;

  /// The ocra secret.
  final String ocraSecret;

  /// The device id.
  final int deviceId;

  /// Whether to scramble the pin code or not
  final bool scramblePin;

  /// The Firebase notification token
  final String? notifcationToken;

  /// Extra widget like contact us button
  final Widget? extraChild;

  /// Creates a new [_LockScreen].
  const _LockScreen({
    super.key,
    super.pinLength = 6,
    required this.title,
    required this.onAuthenticated,
    this.useBiometrics = false,
    required this.ocraSecret,
    required this.deviceId,
    this.scramblePin = false,
    required this.notifcationToken,
    this.extraChild,
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
            final authenticationCubit = context.read<AuthenticationCubit>();
            await authenticationCubit.getUserDetails(state.token!);

            final user = authenticationCubit.state.user;

            if (user != null) {
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
          listener: (context, state) {
            accessPin = '';
          },
        ),
      ],
      child: LayerScaffold(
        backgroundColor: layerDesign.surfaceOctonary1,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Expanded(
                  child: PinPadView(
                    scramblePin: widget.scramblePin,
                    pinLenght: widget.pinLength,
                    pin: accessPin,
                    title: widget.title,
                    disabled: disabled,
                    warning: error.localize(
                      translation,
                      state.remainingAttempts,
                    ),
                    onChanged: (pin) async {
                      accessPin = pin;
                      if (pin.length == widget.pinLength) {
                        final authenticationCubit =
                            context.read<AuthenticationCubit>();
                        await context
                            .read<OcraAuthenticationCubit>()
                            .generateToken(
                              password: accessPin,
                            );
                        final session = await _getDeviceSession();
                        await authenticationCubit.verifyAccessPin(
                          pin,
                          deviceInfo: session,
                          userToken: context
                              .read<OcraAuthenticationCubit>()
                              .state
                              .token,
                          notificationToken: widget.notifcationToken,
                        );
                      }
                    },
                    showBiometrics: widget.useBiometrics,
                    onBiometrics: _onBiometrics,
                  ),
                ),
                if (widget.extraChild != null) widget.extraChild!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DeviceSession> _getDeviceSession() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    var info;
    if (Platform.isAndroid) {
      info = await deviceInfoPlugin.androidInfo;
    }
    if (Platform.isIOS) {
      info = await deviceInfoPlugin.iosInfo;
    }
    final model = await context.read<AuthenticationCubit>().getModelName();
    final carrierName = await CarrierInfo.carrierName;
    final session = DeviceSession(
        model: model,
        carrier: carrierName,
        deviceName: Platform.isAndroid ? info.device : info.name,
        osVersion:
            Platform.isAndroid ? info.version.release : info.systemVersion,
        resolution:
            Resolution(window.physicalSize.width, window.physicalSize.height));
    return session;
  }

  /// Method called when the user has completed the biometric authentication
  /// successfully.
  Future<void> _onBiometrics() async {
    final storageCubit = context.read<StorageCreator>().create();
    await storageCubit.loadAccessPin();

    accessPin = storageCubit.state.accessPin;

    final ocraCubit = context.read<OcraAuthenticationCubit>();
    await ocraCubit.generateToken(
      password: accessPin,
    );

    if (ocraCubit.state.error == OcraAuthenticationError.none &&
        ocraCubit.state.token != null) {
      final session = await _getDeviceSession();
      final authenticationCubit = context.read<AuthenticationCubit>();
      await authenticationCubit.verifyAccessPin(
        accessPin,
        deviceInfo: session,
        notificationToken: widget.notifcationToken,
        userToken: context.read<OcraAuthenticationCubit>().state.token,
      );
    }
  }
}
