import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layer_sdk.dart';

import '../../cubits.dart';
import '../../widgets/header/sdk_header.dart';

/// A screen for validating an OTP.
class OTPScreen extends StatefulWidget {
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
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with FullScreenLoaderMixin {
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

  @override
  void initState() {
    super.initState();

    _isVerifying = widget.isVerifying;
    _isResending = widget.isResending;
    _shouldClearCode = widget.shouldClearCode;

    _remainingTime = widget.resendInterval;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant OTPScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isVerifying != widget.isVerifying) {
      isVerifying = widget.isVerifying;
    }

    if (oldWidget.isResending != widget.isResending) {
      isResending = widget.isResending;
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

    var maskedNumber = '•••••';
    if (mobileNumber.length > 3) {
      final last3Digits = mobileNumber.substring(
          mobileNumber.length - 4, mobileNumber.length - 1);
      maskedNumber = '$maskedNumber$last3Digits';
    } else {
      maskedNumber = '$maskedNumber$mobileNumber';
    }

    return Scaffold(
      appBar: SDKHeader(
        title: widget.title,
        prefixSvgIcon: DKImages.arrowLeft,
        onPrefixIconPressed: () => Navigator.pop(context),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    .replaceAll('{phone}', maskedNumber),
                style: design.bodyM(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              _PinWidgetRow(
                onPinSet: widget.onOTPCode,
                hasError: verificationError != null,
                shouldClearCode: shouldClearCode,
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
            ],
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

class _PinWidgetRow extends StatefulWidget {
  final ValueChanged<String> onPinSet;

  final bool hasError;

  final bool shouldClearCode;

  const _PinWidgetRow({
    Key? key,
    required this.onPinSet,
    this.hasError = false,
    this.shouldClearCode = false,
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
  void didUpdateWidget(covariant _PinWidgetRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasError != widget.hasError && widget.hasError) {
      _clearPins();
    }

    if (oldWidget.shouldClearCode != widget.shouldClearCode &&
        widget.shouldClearCode) {
      _clearPins();
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
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
            ),
          ),
        ],
      );

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

  const _PinWidget({
    Key? key,
    required this.onFill,
    required this.onDelete,
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
          if (v.replaceAll(_PinWidgetRowState.emptyChar, '').isNotEmpty) {
            onFill();
          } else {
            onDelete(v.isEmpty);
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
        ],
      ),
    );
  }
}
