import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layer_sdk.dart';
import '../../cubits.dart';
import '../../widgets/header/sdk_header.dart';

/// A screen for validating an OTP.
class OTPScreen extends StatelessWidget {
  /// The title for the header.
  final String title;

  /// The amount of time in seconds the user has to wait to request
  /// a new OTP code.
  ///
  /// Defaults to `120` seconds.
  final int resendInterval;

  /// Optional image builder.
  final WidgetBuilder? imageBuilder;

  /// Callback called when the OTP code has been set by the user.
  final ValueSetter<String> onOTPCode;

  /// Whether if the OTP code is being verfied.
  /// Default is `false`.
  final bool isVerifying;

  /// The verification error.
  final String? verificationError;

  /// Callback called when the user has pressed the resend OTP code button.
  final VoidCallback onResend;

  /// Whether if the OTP code is being resent.
  /// Default is `false`.
  final bool isResending;

  /// Used for clearing the otp code input.
  ///
  /// If `true` and the previous time this widget was build, this parameter
  /// was `false` the controllers for the otp code will clear the current value.
  /// Usually used for clearing the previous code when there was an error.
  final bool shouldClearCode;

  /// Whether or not the mobile number should be shown.
  ///
  /// Use this parameter when the OTP screen is being used on a unauthenticated
  /// state where the application doesn't have the customer information.
  ///
  /// Defaults to `true`.
  final bool showMobileNumber;

  /// Whether if the biometrics should be shown (if enabled).
  ///
  /// This will trigger the OCRA authentication for generating a OCRA challenge
  /// and this challenge will be sent back using the [onOCRAChallenge] callback.
  ///
  /// Default is `false`.
  final bool showBiometrics;

  /// The callback called when the OCRA client response is generated.
  final ValueSetter<String>? onOCRAClientResponse;

  /// The callback called when the send OTP code gets pressed.
  final Future<bool> Function()? onSendOTPCode;

  /// Creates a new [OTPScreen].
  const OTPScreen({
    Key? key,
    required this.title,
    this.resendInterval = 120,
    this.imageBuilder,
    required this.onOTPCode,
    this.isVerifying = false,
    this.verificationError,
    this.shouldClearCode = false,
    required this.onResend,
    this.isResending = false,
    this.showMobileNumber = true,
    this.showBiometrics = false,
    this.onOCRAClientResponse,
    this.onSendOTPCode,
  })  : assert(
          !showBiometrics || onOCRAClientResponse != null,
          'Biometrics should show but the OCRA client response '
          'callback was not indicated',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<BiometricsCubit>(
        create: (context) => context.read<BiometricsCreator>().create(),
        child: _OTPScreen(
          title: title,
          resendInterval: resendInterval,
          imageBuilder: imageBuilder,
          onOTPCode: onOTPCode,
          isVerifying: isVerifying,
          verificationError: verificationError,
          shouldClearCode: shouldClearCode,
          onResend: onResend,
          isResending: isResending,
          showMobileNumber: showMobileNumber,
          showBiometrics: showBiometrics,
          onOCRAClientResponse: onOCRAClientResponse,
          onSendOTPCode: onSendOTPCode,
        ),
      );
}

/// A screen for validating an OTP.
class _OTPScreen extends StatefulWidget {
  /// The title for the header.
  final String title;

  /// The amount of time in seconds the user has to wait to request
  /// a new OTP code.
  ///
  /// Defaults to `120` seconds.
  final int resendInterval;

  /// Optional image builder.
  final WidgetBuilder? imageBuilder;

  /// Callback called when the OTP code has been set by the user.
  final ValueSetter<String> onOTPCode;

  /// Whether if the OTP code is being verfied.
  /// Default is `false`.
  final bool isVerifying;

  /// The verification error.
  final String? verificationError;

  /// Callback called when the user has pressed the resend OTP code button.
  final VoidCallback onResend;

  /// Whether if the OTP code is being resent.
  /// Default is `false`.
  final bool isResending;

  /// Used for clearing the otp code input.
  ///
  /// If `true` and the previous time this widget was build, this parameter
  /// was `false` the controllers for the otp code will clear the current value.
  /// Usually used for clearing the previous code when there was an error.
  final bool shouldClearCode;

  /// Whether or not the mobile number should be shown.
  ///
  /// Use this parameter when the OTP screen is being used on a unauthenticated
  /// state where the application doesn't have the customer information.
  ///
  /// Defaults to `true`.
  final bool showMobileNumber;

  /// Whether if the biometrics should be shown (if enabled).
  ///
  /// This will trigger the OCRA authentication for generating a OCRA challenge
  /// and this challenge will be sent back using the [onOCRAChallenge] callback.
  ///
  /// Default is `false`.
  final bool showBiometrics;

  /// The callback called when the OCRA client response is generated.
  final ValueSetter<String>? onOCRAClientResponse;

  /// The callback called when the send OTP code gets pressed.
  final Future<bool> Function()? onSendOTPCode;

  /// Creates a new [_OTPScreen].
  const _OTPScreen({
    Key? key,
    required this.title,
    this.resendInterval = 120,
    this.imageBuilder,
    required this.onOTPCode,
    this.isVerifying = false,
    this.verificationError,
    this.shouldClearCode = false,
    required this.onResend,
    this.isResending = false,
    this.showMobileNumber = true,
    this.showBiometrics = false,
    this.onOCRAClientResponse,
    this.onSendOTPCode,
  })  : assert(
          !showBiometrics || onOCRAClientResponse != null,
          'Biometrics should show but the OCRA client response '
          'callback was not indicated',
        ),
        super(key: key);

  @override
  State<_OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<_OTPScreen> with FullScreenLoaderMixin {
  late int _remainingTime;
  Timer? _timer;

  bool get resendEnabled => _remainingTime <= 0;

  late bool _isVerifying;
  bool get isVerifying => _isVerifying;
  set isVerifying(bool isVerifying) =>
      setState(() => _isVerifying = isVerifying);

  String? _verificationError;
  String? get verificationError => _verificationError;
  set verificationError(String? verificationError) =>
      setState(() => _verificationError = verificationError);

  late bool _isResending;
  bool get isResending => _isResending;
  set isResending(bool isResending) =>
      setState(() => _isResending = isResending);

  late bool _shouldClearCode;
  bool get shouldClearCode => _shouldClearCode;
  set shouldClearCode(bool shouldClearCode) =>
      setState(() => _shouldClearCode = shouldClearCode);

  bool _showBiometricsButton = false;
  bool get showBiometricsButton => _showBiometricsButton;
  set showBiometricsButton(bool showBiometricsButton) =>
      setState(() => _showBiometricsButton = showBiometricsButton);

  bool _isSendingOTPCode = false;
  bool get isSendingOTPCode => _isSendingOTPCode;
  set isSendingOTPCode(bool isSendingOTPCode) =>
      setState(() => _isSendingOTPCode = isSendingOTPCode);

  late bool _showOTPCodeInput;
  bool get showOTPCodeInput => _showOTPCodeInput;
  set showOTPCodeInput(bool showOTPCodeInput) =>
      setState(() => _showOTPCodeInput = showOTPCodeInput);

  @override
  void initState() {
    super.initState();

    _isVerifying = widget.isVerifying;
    _isResending = widget.isResending;
    _shouldClearCode = widget.shouldClearCode;
    _showOTPCodeInput = !widget.showBiometrics;

    _remainingTime = widget.resendInterval;
    _startTimer();

    if (widget.showBiometrics) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final biometricsCubit = context.read<BiometricsCubit>();
        final storageCubit = context.read<StorageCreator>().create();

        await Future.wait([
          biometricsCubit.initialize(),
          storageCubit.loadAuthenticationSettings(),
        ]);

        final canUseBiometrics =
            biometricsCubit.state.canUseBiometrics ?? false;
        final useBiometrics =
            storageCubit.state.authenticationSettings.useBiometrics;

        showBiometricsButton = canUseBiometrics && useBiometrics;

        if (showBiometricsButton) {
          _authenticateBiometrics();
        } else if (widget.onSendOTPCode != null) {
          isSendingOTPCode = true;
          showOTPCodeInput = await widget.onSendOTPCode!();
          isSendingOTPCode = false;
        }
      });
    }
  }

  /// Preforms a biometrics authentication. If successful, it generates an
  /// OCRA challenge.
  void _authenticateBiometrics() async {
    final biometricsCubit = context.read<BiometricsCubit>();

    await biometricsCubit.authenticate(
      localizedReason: Translation.of(context).translate(
        'biometric_dialog_description',
      ),
    );

    if (biometricsCubit.state.authenticated ?? false) {
      final storageCubit = context.read<StorageCreator>().create();

      await Future.wait([
        storageCubit.loadLastLoggedUser(),
        storageCubit.loadOcraSecretKey(),
      ]);

      final deviceId = storageCubit.state.currentUser!.deviceId!;
      final ocraSecret = storageCubit.state.ocraSecretKey!;
      final accessPin = storageCubit.state.currentUser!.accessPin!;

      final ocraAuthenticationCubit =
          context.read<OcraAuthenticationCreator>().create(
                deviceId: deviceId,
                ocraSecret: ocraSecret,
              );

      await ocraAuthenticationCubit.generateClientResponse(
        password: accessPin,
      );

      final ocraClientResponse = ocraAuthenticationCubit.state.clientResponse;
      if (ocraClientResponse != null) {
        widget.onOCRAClientResponse!(ocraClientResponse);
      }
    }
  }

  @override
  void didUpdateWidget(covariant _OTPScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isVerifying != widget.isVerifying) {
      isVerifying = widget.isVerifying;
    }

    if (oldWidget.isResending != widget.isResending) {
      isResending = widget.isResending;
      if (!isResending) {
        _startTimer();
      }
    }

    if (oldWidget.verificationError != widget.verificationError) {
      verificationError = widget.verificationError;
    }

    if (oldWidget.shouldClearCode != widget.shouldClearCode) {
      shouldClearCode = widget.shouldClearCode;
    }
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);

    final mobileNumber = context.select<AuthenticationCubit, String?>(
          (cubit) => cubit.state.user?.mobileNumber,
        ) ??
        '';

    var maskedNumber = '𖧹𖧹𖧹𖧹';
    if (mobileNumber.length > 3) {
      final last3Digits = mobileNumber.substring(
          mobileNumber.length - 5, mobileNumber.length - 1);
      maskedNumber = '$maskedNumber$last3Digits';
    } else {
      maskedNumber = '$maskedNumber$mobileNumber';
    }

    return LayerScaffold(
      extendBodyBehindAppBar: true,
      appBar: SDKHeader(
        title: widget.title,
        prefixSvgIcon: DKImages.arrowLeft,
        onPrefixIconPressed: () => Navigator.pop(context),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: MediaQuery.of(context).size.height - 32.0,
            padding: const EdgeInsets.only(top: 120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.imageBuilder != null) ...[
                  widget.imageBuilder!(context),
                  const SizedBox(height: 24.0),
                ],
                Text(
                  translation
                      .translate('enter_code_sent_to_placeholder')
                      .replaceAll(
                        '{phone}',
                        widget.showMobileNumber ? maskedNumber : '',
                      ),
                  style: design.bodyM(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: child,
                  ),
                  child: showOTPCodeInput
                      ? PinWidgetRow(
                          onPinSet: widget.onOTPCode,
                          hasError: verificationError != null,
                          shouldClearCode: shouldClearCode,
                        )
                      : Center(
                          child: DKButton(
                            title: translation.translate('send'),
                            type: DKButtonType.brandPlain,
                            status: isSendingOTPCode
                                ? DKButtonStatus.loading
                                : DKButtonStatus.idle,
                            expands: false,
                            onPressed: () async {
                              assert(widget.onSendOTPCode != null);

                              isSendingOTPCode = true;
                              showOTPCodeInput = await widget.onSendOTPCode!();
                              isSendingOTPCode = false;
                            },
                          ),
                        ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: child,
                  ),
                  child: verificationError != null
                      ? SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16.0),
                              Text(
                                verificationError!,
                                style: design.bodyM(
                                  color: design.errorPrimary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 34.0),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: child,
                  ),
                  child: showOTPCodeInput
                      ? Center(
                          child: DKButton(
                            title: resendEnabled
                                ? translation.translate('resend')
                                : translation
                                    .translate('resend_code_in_placeholder')
                                    .replaceAll(
                                      '{time}',
                                      _remainingTime.toMinutesTimestamp(),
                                    ),
                            type: DKButtonType.brandPlain,
                            status: isResending
                                ? DKButtonStatus.loading
                                : resendEnabled
                                    ? DKButtonStatus.idle
                                    : DKButtonStatus.disabled,
                            expands: false,
                            onPressed: () {
                              if (!resendEnabled) return;
                              widget.onResend();
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                if (showBiometricsButton) ...[
                  Spacer(),
                  DKButton(
                    type: DKButtonType.basePlain,
                    title: translation.translate('proceed_with_biometrics'),
                    iconPath: FLImages.biometrics,
                    onPressed: _authenticateBiometrics,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    if (!mounted) return;

    if (_timer?.isActive ?? false) _timer?.cancel();

    _remainingTime = widget.resendInterval;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final remaining = _remainingTime - 1;
        if (remaining <= 0) {
          _timer?.cancel();
        }

        if (!mounted) return;
        setState(() => _remainingTime = remaining);
      },
    );
  }
}
