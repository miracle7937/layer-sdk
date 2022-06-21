import 'dart:async';

import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/environment.dart';
import '../../../../features/dpa.dart';
import '../../../extensions.dart';
import '../../../mixins.dart';
import '../../../utils.dart';
import '../../../widgets.dart';

/// DPA Screen that handles the [DPAScreenType.otp] screen type.
class DPAOTPScreen extends StatefulWidget {
  /// Optional custom DPAHeader widget.
  final Widget? customDPAHeader;

  /// The amount of time in seconds the user has to wait to request
  /// a new OTP code.
  ///
  /// Defaults to `120` seconds.
  final int resendInterval;

  /// Creates a new [DPAOTPScreen] instace.
  const DPAOTPScreen({
    Key? key,
    this.customDPAHeader,
    this.resendInterval = 120,
  }) : super(key: key);

  @override
  State<DPAOTPScreen> createState() => _DPAOTPScreenState();
}

class _DPAOTPScreenState extends State<DPAOTPScreen>
    with FullScreenLoaderMixin {
  final _otpController = TextEditingController();

  late int _remainingTime;

  Timer? _timer;

  bool get resendEnabled => _remainingTime <= 0;

  @override
  void initState() {
    _remainingTime = widget.resendInterval;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    if (_timer?.isActive ?? false) _timer?.cancel();

    super.dispose();
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

    return BlocListener<DPAProcessCubit, DPAProcessState>(
      listenWhen: (previous, current) =>
          previous.actions.contains(DPAProcessBusyAction.resendingCode) &&
          !current.actions.contains(DPAProcessBusyAction.resendingCode),
      listener: (_, __) => _startTimer(),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: _PinWidgetRow(
                          onPinSet: _onPinSet,
                        ),
                      ),
                      DKButton(
                        title: resendEnabled
                            ? translation.translate('resend')
                            : translation
                                .translate('resend_code_in_placeholder')
                                .replaceAll(
                                  '{time}',
                                  _remainingTime.toMinutesTimestamp(),
                                ),
                        type: DKButtonType.brandPlain,
                        status: isResendingCode
                            ? DKButtonStatus.loading
                            : resendEnabled
                                ? DKButtonStatus.idle
                                : DKButtonStatus.disabled,
                        expands: false,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        onPressed: () {
                          if (!resendEnabled) return;

                          context.read<DPAProcessCubit>().resendCode();
                        },
                      ),
                      if (isPhoneOTP)
                        DKButton(
                          title: translation.translate('change_phone_number'),
                          type: DKButtonType.basePlain,
                          expands: false,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          status: isRequestingPhoneChange
                              ? DKButtonStatus.loading
                              : DKButtonStatus.idle,
                          onPressed: () => context
                              .read<DPAProcessCubit>()
                              .requestPhoneNumberChange(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isSteppingForward) _Loader(),
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

  void _onPinSet(String pin) async {
    final cubit = context.read<DPAProcessCubit>();
    final variable = cubit.state.process.variables.first;

    await cubit.updateValue(
      variable: variable,
      newValue: pin,
    );

    cubit.stepOrFinish();
  }
}

class _PinWidgetRow extends StatefulWidget {
  final ValueChanged<String> onPinSet;

  const _PinWidgetRow({
    Key? key,
    required this.onPinSet,
  }) : super(key: key);

  @override
  State<_PinWidgetRow> createState() => _PinWidgetRowState();
}

class _PinWidgetRowState extends State<_PinWidgetRow>
    with FullScreenLoaderMixin {
  /// TODO: This widget should handle multiple OTP lengths
  /// TODO: This widget should be using the design kit.
  late final TextEditingController firstPin;
  late final TextEditingController secondPin;
  late final TextEditingController thirdPin;
  late final TextEditingController fourthPin;

  late final FocusNode secondNode;
  late final FocusNode thirdNode;
  late final FocusNode fourthNode;

  @override
  void initState() {
    super.initState();
    firstPin = TextEditingController();
    secondPin = TextEditingController();
    thirdPin = TextEditingController();
    fourthPin = TextEditingController();

    secondNode = FocusNode();
    thirdNode = FocusNode();
    fourthNode = FocusNode();
  }

  @override
  void dispose() {
    firstPin.dispose();
    secondPin.dispose();
    thirdPin.dispose();
    fourthPin.dispose();

    secondNode.dispose();
    thirdNode.dispose();
    fourthNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _PinWidget(
            controller: firstPin,
            onFill: () => _onPinUpdated(
              next: secondNode,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _PinWidget(
            controller: secondPin,
            onFill: () => _onPinUpdated(
              next: thirdNode,
            ),
            node: secondNode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _PinWidget(
            controller: thirdPin,
            onFill: () => _onPinUpdated(
              next: fourthNode,
            ),
            node: thirdNode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _PinWidget(
            controller: fourthPin,
            node: fourthNode,
            onFill: _onPinUpdated,
          ),
        ),
      ],
    );
  }

  void _onPinUpdated({
    FocusNode? next,
  }) {
    final otp = [
      firstPin.text,
      secondPin.text,
      thirdPin.text,
      fourthPin.text,
    ].where((e) => e.isNotEmpty).join();

    next?.requestFocus();

    // TODO: Remove this magic number.
    if (otp.length == 4) widget.onPinSet(otp);
  }
}

class _PinWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? node;

  final VoidCallback onFill;

  const _PinWidget({
    Key? key,
    required this.onFill,
    required this.controller,
    this.node,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: design.surfaceSeptenary4,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
        color: design.surfaceNonary3,
      ),
      child: TextField(
        controller: controller,
        focusNode: node,
        textAlign: TextAlign.center,
        style: design.bodyXXL(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        onChanged: (v) {
          if (v.isNotEmpty) {
            onFill();
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    return Container(
      // TODO: Add this color to the design system (modal/overlay)
      color: Color(0xFF191A19).withOpacity(0.64),
      child: Center(
        child: DKLoader(
          size: 72,
          startColor: design.basePrimaryWhite,
          endColor: design.basePrimaryWhite.withOpacity(0),
        ),
      ),
    );
  }
}
