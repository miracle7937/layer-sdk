import 'dart:async';
import 'dart:math';

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

  /// If the screen is onboarding
  final bool isOnboarding;

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
    this.isOnboarding = false,
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
                      if (isPhoneOTP && widget.isOnboarding)
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

  void _onPinSet(String pin) async {
    final cubit = context.read<DPAProcessCubit>();
    final variable = cubit.state.process.variables.first;

    await cubit.updateValue(
      variable: variable,
      newValue: pin,
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
  // In order to allow for deleting the pin digits without manually switching
  // focus to another field we're populating each text field initially with
  // an empty, zero-width character.
  static const String emptyChar = '\u200b';

  /// TODO: This widget should handle multiple OTP lengths
  /// TODO: This widget should be using the design kit.
  late final TextEditingController firstPin;
  late final TextEditingController secondPin;
  late final TextEditingController thirdPin;
  late final TextEditingController fourthPin;

  late final FocusNode firstNode;
  late final FocusNode secondNode;
  late final FocusNode thirdNode;
  late final FocusNode fourthNode;

  final _pastKey = GlobalKey();
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    firstPin = TextEditingController(text: emptyChar);
    secondPin = TextEditingController(text: emptyChar);
    thirdPin = TextEditingController(text: emptyChar);
    fourthPin = TextEditingController(text: emptyChar);

    firstNode = FocusNode();
    secondNode = FocusNode();
    thirdNode = FocusNode();
    fourthNode = FocusNode();

    firstNode.requestFocus();
  }

  @override
  void dispose() {
    firstPin.dispose();
    secondPin.dispose();
    thirdPin.dispose();
    fourthPin.dispose();

    firstNode.dispose();
    secondNode.dispose();
    thirdNode.dispose();
    fourthNode.dispose();
    _clearCurrentEntry();
    super.dispose();
  }

  void _onPaste() async {
    _clearCurrentEntry();
    final data = await Clipboard.getData("text/plain");
    final pastedText = data?.text;
    if (pastedText?.isNotEmpty ?? false) {
      final formattedPastedText =
          pastedText!.trim().substring(0, min(pastedText.trim().length, 4));
      final digits = formattedPastedText.split("");
      final invalid = digits.any((digit) => int.tryParse(digit) == null);
      if (invalid) return;
      if (digits.length == 4) {
        firstPin.text = digits[0];
        secondPin.text = digits[1];
        thirdPin.text = digits[2];
        fourthPin.text = digits[3];
        FocusScope.of(context).unfocus();
        widget.onPinSet(digits.join().replaceAll(emptyChar, ''));
      } else if (digits.length == 3) {
        firstPin.text = digits[0];
        secondPin.text = digits[1];
        thirdPin.text = digits[2];
        fourthNode.requestFocus();
      } else if (digits.length == 2) {
        firstPin.text = digits[0];
        secondPin.text = digits[1];
        thirdNode.requestFocus();
      } else if (digits.length == 1) {
        firstPin.text = digits[0];
        secondNode.requestFocus();
      }
    }
  }

  void _clearCurrentEntry() {
    if (_entry != null) {
      try {
        _entry!.remove();
        _entry = null;
      } on Exception catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DPAProcessCubit, DPAProcessState>(
      listenWhen: (previous, current) =>
          previous.actions.contains(DPAProcessBusyAction.steppingForward) &&
          !current.actions.contains(DPAProcessBusyAction.steppingForward),
      listener: (context, state) => _clearPins(),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          GestureDetector(
            onTap: () {
              _clearCurrentEntry();
              if (firstPin.text.isEmpty || firstPin.text == emptyChar) {
                firstNode.requestFocus();
              } else if (secondPin.text.isEmpty ||
                  secondPin.text == emptyChar) {
                secondNode.requestFocus();
              } else if (thirdPin.text.isEmpty || thirdPin.text == emptyChar) {
                thirdNode.requestFocus();
              } else if (fourthPin.text.isEmpty ||
                  fourthPin.text == emptyChar) {
                fourthNode.requestFocus();
              } else {
                // all are filled, set the cursor at the end
                fourthNode.requestFocus();
              }
            },
            onLongPress: () {
              _clearCurrentEntry();
              final size = MediaQuery.of(context).size;
              _entry = OverlayEntry(
                builder: (context) => Positioned.directional(
                  textDirection: TextDirection.ltr,
                  width: 75,
                  height: 37,
                  top: _pastKey._globalPaintBounds == null
                      ? size.height / 2
                      : _pastKey._globalPaintBounds!.top - 45,
                  start: _pastKey._globalPaintBounds == null
                      ? size.width / 2
                      : (_pastKey._globalPaintBounds!.right - 75) / 2,
                  child: GestureDetector(
                    onTap: _onPaste,
                    child: Container(
                      width: 75,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            spreadRadius: 1,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Material(
                          color: Color.fromRGBO(237, 237, 237, 1),
                          child: Text("Paste"),
                        ),
                      ),
                    ),
                  ),
                ),
              );
              Overlay.of(context)!.insert(_entry!);
            },
            child: Container(
              key: _pastKey,
              child: AbsorbPointer(
                absorbing: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _PinWidget(
                        controller: firstPin,
                        onFill: () => _onPinUpdated(
                          next: secondNode,
                          self: firstNode,
                        ),
                        onDelete: (clearPrevious) => _onDelete(
                          controller: firstPin,
                          clearPrevious: clearPrevious,
                        ),
                        node: firstNode,
                        onSubmitted: (_) => _clearCurrentEntry(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _PinWidget(
                        controller: secondPin,
                        onFill: () => _onPinUpdated(
                          next: thirdNode,
                          self: secondNode,
                        ),
                        onDelete: (clearPrevious) => _onDelete(
                          controller: secondPin,
                          previousController: firstPin,
                          previousNode: firstNode,
                          clearPrevious: clearPrevious,
                        ),
                        node: secondNode,
                        onSubmitted: (_) => _clearCurrentEntry(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _PinWidget(
                        controller: thirdPin,
                        onFill: () => _onPinUpdated(
                          next: fourthNode,
                          self: thirdNode,
                        ),
                        onDelete: (clearPrevious) => _onDelete(
                          controller: thirdPin,
                          previousController: secondPin,
                          previousNode: secondNode,
                          clearPrevious: clearPrevious,
                        ),
                        node: thirdNode,
                        onSubmitted: (_) => _clearCurrentEntry(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _PinWidget(
                        controller: fourthPin,
                        node: fourthNode,
                        onFill: () => _onPinUpdated(
                          self: fourthNode,
                        ),
                        onDelete: (clearPrevious) => _onDelete(
                          controller: fourthPin,
                          previousController: thirdPin,
                          previousNode: thirdNode,
                          clearPrevious: clearPrevious,
                        ),
                        onSubmitted: (_) => _clearCurrentEntry(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onPinUpdated({
    required FocusNode self,
    FocusNode? next,
  }) {
    final otp = [
      firstPin.text,
      secondPin.text,
      thirdPin.text,
      fourthPin.text,
    ].join().replaceAll(emptyChar, '');

    next?.requestFocus();

    // TODO: Remove this magic number.
    if (otp.length == 4) {
      self.unfocus();
      widget.onPinSet(otp);
    }
  }

  void _onDelete({
    required TextEditingController controller,
    required bool clearPrevious,
    TextEditingController? previousController,
    FocusNode? previousNode,
  }) {
    if (clearPrevious) {
      previousController?.text = emptyChar;
    }
    controller.text = emptyChar;

    previousNode?.requestFocus();
  }

  void _clearPins() {
    final pins = [
      firstPin,
      secondPin,
      thirdPin,
      fourthPin,
    ];

    for (final pin in pins) {
      pin.text = emptyChar;
    }
  }
}

class _PinWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? node;

  final VoidCallback onFill;
  final void Function(bool clearPrevious) onDelete;
  final ValueChanged<String>? onSubmitted;

  const _PinWidget({
    Key? key,
    required this.onFill,
    required this.onDelete,
    required this.controller,
    this.node,
    this.onSubmitted,
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
          if (v.replaceAll(_PinWidgetRowState.emptyChar, '').isNotEmpty) {
            onFill();
          } else {
            onDelete(v.isEmpty);
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
        ],
        onSubmitted: onSubmitted,
      ),
    );
  }
}

/// GlobalKeyExtension
extension _GlobalKeyExtension on GlobalKey {
  /// globalPaintBounds
  Rect? get _globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject?.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
