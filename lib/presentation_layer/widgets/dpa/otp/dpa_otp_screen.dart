import 'dart:async';

import 'package:collection/collection.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/environment.dart';
import '../../../../features/dpa.dart';
import '../../../creators.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';
import '../../../mixins.dart';
import '../../../resources.dart';
import '../../../utils.dart';
import '../../../widgets.dart';

/// DPA Screen that handles the [DPAScreenType.otp] screen type.
class DPAOTPScreen extends StatelessWidget {
  /// Optional custom DPAHeader widget.
  final Widget? customDPAHeader;

  /// If the screen is onboarding
  final bool isOnboarding;

  /// The amount of time in seconds the user has to wait to request
  /// a new OTP code.
  ///
  /// Defaults to `120` seconds.
  final int resendInterval;

  /// Creates a new [_DPAOTPScreen] instace.
  const DPAOTPScreen({
    Key? key,
    this.customDPAHeader,
    this.resendInterval = 120,
    this.isOnboarding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<BiometricsCubit>(
        create: (context) => context.read<BiometricsCreator>().create(),
        child: _DPAOTPScreen(
          customDPAHeader: customDPAHeader,
          isOnboarding: isOnboarding,
          resendInterval: resendInterval,
        ),
      );
}

/// DPA Screen that handles the [DPAScreenType.otp] screen type.
class _DPAOTPScreen extends StatefulWidget {
  /// Optional custom DPAHeader widget.
  final Widget? customDPAHeader;

  /// If the screen is onboarding
  final bool isOnboarding;

  /// The amount of time in seconds the user has to wait to request
  /// a new OTP code.
  ///
  /// Defaults to `120` seconds.
  final int resendInterval;

  /// Creates a new [_DPAOTPScreen] instace.
  const _DPAOTPScreen({
    Key? key,
    this.customDPAHeader,
    this.resendInterval = 120,
    this.isOnboarding = false,
  }) : super(key: key);

  @override
  State<_DPAOTPScreen> createState() => _DPAOTPScreenState();
}

class _DPAOTPScreenState extends State<_DPAOTPScreen>
    with FullScreenLoaderMixin {
  final _otpController = TextEditingController();

  late int _remainingTime;

  Timer? _timer;

  bool get resendEnabled => _remainingTime <= 0;

  /// Whether if the 2FA is compatible with OCRA (biometrics).
  late bool hasOCRA;

  bool _showBiometricsButton = false;
  bool get showBiometricsButton => _showBiometricsButton;
  set showBiometricsButton(bool showBiometricsButton) => mounted
      ? setState(() => _showBiometricsButton = showBiometricsButton)
      : null;

  late bool _showOTPCodeInput;
  bool get showOTPCodeInput => _showOTPCodeInput;
  set showOTPCodeInput(bool showOTPCodeInput) =>
      mounted ? setState(() => _showOTPCodeInput = showOTPCodeInput) : null;

  bool _shouldClearCode = false;
  bool get shouldClearCode => _shouldClearCode;
  set shouldClearCode(bool shouldClearCode) =>
      mounted ? setState(() => _shouldClearCode = shouldClearCode) : null;

  @override
  void initState() {
    _remainingTime = widget.resendInterval;
    _startTimer();

    final state = context.read<DPAProcessCubit>().state;

    hasOCRA = state.process.variables.singleWhereOrNull(
          (variable) => variable.key == 'ocra',
        ) !=
        null;

    _showOTPCodeInput = !hasOCRA;

    if (hasOCRA) {
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
        } else {
          final dpaCubit = context.read<DPAProcessCubit>();
          await dpaCubit.resendCode();

          showOTPCodeInput = !dpaCubit.state.actionHasErrors(
            DPAProcessBusyAction.resendingCode,
          );
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    if (_timer?.isActive ?? false) _timer?.cancel();

    super.dispose();
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
        _onSecondFactorIntroduced(
          ocraClientResponse: ocraClientResponse,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);

    final state = context.watch<DPAProcessCubit>().state;
    final process = state.process;

    final isSteppingForward = state.actions.contains(
      DPAProcessBusyAction.steppingForward,
    );

    final isRequestingPhoneChange = state.actions.contains(
      DPAProcessBusyAction.requestingPhoneChange,
    );

    final isResendingCode = state.actions.contains(
      DPAProcessBusyAction.resendingCode,
    );

    final imageUrl = process.stepProperties?.image;

    final isPhoneOTP = process.stepProperties?.maskedNumber != null;

    final effectiveHeader = widget.customDPAHeader ??
        DPAHeader(
          process: state.process,
        );

    return MultiBlocListener(
      listeners: [
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (previous, current) =>
              previous.actions.contains(DPAProcessBusyAction.resendingCode) &&
              !current.actions.contains(DPAProcessBusyAction.resendingCode),
          listener: (_, __) => _startTimer(),
        ),
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (previous, current) {
            final secondFactorVariable = current.process.variables
                .singleWhereOrNull(
                    (variable) => variable.key == 'second_factor_value');

            return secondFactorVariable?.value == null &&
                previous.process != current.process;
          },
          listener: (context, state) async {
            shouldClearCode = true;
            await Future.delayed(Duration(milliseconds: 300));
            shouldClearCode = false;
          },
        ),
      ],
      child: Stack(
        children: [
          Column(
            children: [
              effectiveHeader,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (imageUrl != null)
                        NetworkImageContainer(
                          imageURL: imageUrl,
                          customToken:
                              EnvironmentConfiguration.current.defaultToken,
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16.0,
                          imageUrl != null ? 24.0 : 0.0,
                          16.0,
                          0.0,
                        ),
                        child: Text(
                          isPhoneOTP
                              ? translation
                                  .translate('enter_code_sent_to_placeholder')
                                  .replaceAll(
                                    '{phone}',
                                    process.stepProperties?.maskedNumber ?? '',
                                  )
                              : translation
                                  .translate(
                                    'enter_code_sent_to_email_placeholder',
                                  )
                                  .replaceAll(
                                    '{email}',
                                    process.stepProperties?.email ?? '',
                                  ),
                          style: design.bodyM(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) => SizeTransition(
                          sizeFactor: animation,
                          child: child,
                        ),
                        child: showOTPCodeInput
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: PinWidgetRow(
                                      onPinSet: (otpCode) =>
                                          _onSecondFactorIntroduced(
                                        otpCode: otpCode,
                                      ),
                                      shouldClearCode: shouldClearCode,
                                    ),
                                  ),
                                  DKButton(
                                    title: resendEnabled
                                        ? translation.translate('resend')
                                        : translation
                                            .translate(
                                                'resend_code_in_placeholder')
                                            .replaceAll(
                                              '{time}',
                                              _remainingTime
                                                  .toMinutesTimestamp(),
                                            ),
                                    type: DKButtonType.brandPlain,
                                    status: isResendingCode
                                        ? DKButtonStatus.loading
                                        : resendEnabled
                                            ? DKButtonStatus.idle
                                            : DKButtonStatus.disabled,
                                    expands: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    onPressed: () {
                                      if (!resendEnabled) return;

                                      context
                                          .read<DPAProcessCubit>()
                                          .resendCode();
                                    },
                                  ),
                                  if (isPhoneOTP && widget.isOnboarding)
                                    DKButton(
                                      title: translation
                                          .translate('change_phone_number'),
                                      type: DKButtonType.basePlain,
                                      expands: false,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      status: isRequestingPhoneChange
                                          ? DKButtonStatus.loading
                                          : DKButtonStatus.idle,
                                      onPressed: () => context
                                          .read<DPAProcessCubit>()
                                          .requestPhoneNumberChange(),
                                    ),
                                ],
                              )
                            : Center(
                                child: DKButton(
                                  title: translation.translate('send'),
                                  type: DKButtonType.brandPlain,
                                  status: isResendingCode
                                      ? DKButtonStatus.loading
                                      : DKButtonStatus.idle,
                                  expands: false,
                                  onPressed: () async {
                                    final dpaCubit =
                                        context.read<DPAProcessCubit>();
                                    await dpaCubit.resendCode();

                                    showOTPCodeInput =
                                        !dpaCubit.state.actionHasErrors(
                                      DPAProcessBusyAction.resendingCode,
                                    );
                                  },
                                ),
                              ),
                      ),
                      if (showBiometricsButton) ...[
                        const SizedBox(height: 20.0),
                        DKButton(
                          type: DKButtonType.basePlain,
                          title:
                              translation.translate('proceed_with_biometrics'),
                          iconPath: FLImages.biometrics,
                          onPressed: _authenticateBiometrics,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isSteppingForward) DPAFullscreenLoader(),
        ],
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

  void _onSecondFactorIntroduced({
    String? otpCode,
    String? ocraClientResponse,
  }) async {
    assert(otpCode != null || ocraClientResponse != null);

    final cubit = context.read<DPAProcessCubit>();
    final variables = cubit.state.process.variables;
    final variable = variables.first;

    final secondFactorVariable = variables.singleWhereOrNull(
      (variable) =>
          variable.key == (otpCode != null ? 'second_factor_value' : 'ocra'),
    );

    await cubit.updateValue(
      variable: secondFactorVariable ?? variable,
      newValue: otpCode ?? ocraClientResponse,
    );

    final isPhoneOTP = cubit.state.process.stepProperties?.maskedNumber != null;

    cubit.stepOrFinish(
      extraVariables: [
        DPAVariable(
          id: 'timeout',
          type: DPAVariableType.boolean,
          value: false,
          property: DPAVariableProperty(),
        ),
        DPAVariable(
          id: isPhoneOTP ? 'rectify_mobile_number' : 'rectify_email_address',
          type: DPAVariableType.boolean,
          value: false,
          property: DPAVariableProperty(),
        ),
        DPAVariable(
          id: 'enter_code',
          type: DPAVariableType.boolean,
          value: false,
          property: DPAVariableProperty(),
        ),
      ],
    );
  }
}
