import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../creators.dart';
import '../../cubits.dart';
import '../../resources.dart';
import '../../utils.dart';

/// A view for inputing a pin with a pin pad.
class PinPadView extends StatefulWidget {
  /// The pin length.
  /// Default is 6.
  final int pinLenght;

  /// The current entered pin.
  final String pin;

  /// The callback called when the pin changes.
  final ValueChanged<String> onChanged;

  /// The warning message.
  /// If indicated the current pin will reset.
  final String? warning;

  /// Whether if the pin pad view is disabled or not.
  /// Default is `false`.
  final bool disabled;

  /// The title to show on top of the pin dots.
  final String title;

  /// Whether if the biometrics button should appear on the pin
  /// pad.
  final bool showBiometrics;

  /// Callback called when the user has entered the biometrics successfully.
  /// Must be indicated if the [showBiometrics] is `true`.
  final VoidCallback? onBiometrics;

  /// Whether to scramble the pin code or not
  final bool scramblePin;

  /// Creates a new [PinPadView].
  const PinPadView({
    Key? key,
    this.pinLenght = 6,
    required this.pin,
    required this.onChanged,
    this.warning,
    this.disabled = false,
    required this.title,
    this.showBiometrics = false,
    this.onBiometrics,
    this.scramblePin = false,
  }) : assert(!showBiometrics || onBiometrics != null);

  @override
  _PinPadViewState createState() => _PinPadViewState();
}

class _PinPadViewState extends State<PinPadView> {
  late List<int> pinValues;

  @override
  void initState() {
    super.initState();
    pinValues = List<int>.generate(9, (i) => i + 1)..add(0);
    if (widget.scramblePin) {
      pinValues.shuffle();
    }
  }

  /// The buttons that will appear on the pin pad.
  List<PinButton> pinButtons(BuildContext context) {
    final translation = Translation.of(context);

    var pinWidgets = <PinButton>[];

    for (var index = 0; index < pinValues.length - 1; index++) {
      pinWidgets.add(PinButton(
        title: pinValues[index].toString(),
        onPressed: () => widget.onChanged('${widget.pin}${pinValues[index]}'),
        enabled: widget.pin.length < widget.pinLenght,
      ));
    }

    return [
      ...pinWidgets,
      PinButton(
        svgPath: FLImages.biometrics,
        onPressed: () async {
          final biometricsCubit = context.read<BiometricsCubit>();
          await biometricsCubit.authenticate(
            localizedReason: translation.translate(
              'biometric_dialog_description',
            ),
          );

          if (biometricsCubit.state.authenticated ?? false) {
            widget.onBiometrics!();
          }
        },
        enabled: widget.showBiometrics,
        visible: widget.showBiometrics,
      ),
      PinButton(
        title: pinValues[9].toString(),
        onPressed: () => widget.onChanged('${widget.pin}${pinValues[9]}'),
        enabled: widget.pin.length < widget.pinLenght,
      ),
      PinButton(
        svgPath: FLImages.backspace,
        onPressed: () => widget.onChanged(
          widget.pin.substring(0, widget.pin.length - 1),
        ),
        enabled: widget.pin.isNotEmpty,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return BlocProvider<BiometricsCubit>(
      create: (context) => context.read<BiometricsCreator>().create(),
      child: Builder(
        builder: (context) => IgnorePointer(
          ignoring: widget.disabled,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: AutoSizeText(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: layerDesign.bodyM(),
                        maxLines: 3,
                        maxFontSize: 16.0,
                        minFontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 46.0),
                    _buildPinDotsIndicator(layerDesign),
                  ],
                ),
                const SizedBox(height: 72.0),
                Expanded(
                  child: _buildPinPad(layerDesign),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the pin dots indicator.
  Widget _buildPinDotsIndicator(
    LayerDesign layerDesign,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.pinLenght,
              (index) => IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DKRadioButton(
                    selected: widget.pin.length > index,
                  ),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: widget.warning == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: AutoSizeText(
                      widget.warning!,
                      textAlign: TextAlign.center,
                      style: layerDesign.titleM(
                        color: layerDesign.errorPrimary,
                      ),
                      maxFontSize: 16.0,
                      minFontSize: 12.0,
                    ),
                  ),
          ),
        ],
      );

  /// Builds the pin pad view.
  Widget _buildPinPad(
    LayerDesign layerDesign,
  ) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.maxWidth / 3;
          final boxHeight = constraints.maxHeight / 4;

          return Wrap(
            children: pinButtons(context)
                .map(
                  (button) => Container(
                    width: boxWidth,
                    height: boxHeight,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 14.0,
                    ),
                    child: IgnorePointer(
                      ignoring: !button.enabled,
                      child: Visibility(
                        visible: button.visible,
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainState: true,
                        child: button.svgPath == null
                            ? DKButton(
                                customTextWidget: AutoSizeText(
                                  button.title!,
                                  textAlign: TextAlign.center,
                                  style: layerDesign.titleXXXL().copyWith(
                                        height: 1,
                                      ),
                                  maxLines: 1,
                                  maxFontSize: 32.0,
                                  minFontSize: 20.0,
                                ),
                                onPressed: button.onPressed,
                                type: DKButtonType.baseSecondary,
                                shape: BoxShape.circle,
                                expands: false,
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  final buttonSize = constraints.maxHeight >
                                          constraints.maxWidth
                                      ? constraints.maxWidth
                                      : constraints.maxHeight;

                                  return DKButton.icon(
                                    iconPath: button.svgPath!,
                                    onPressed: button.onPressed,
                                    type: DKButtonType.basePlain,
                                    shape: BoxShape.circle,
                                    expands: false,
                                    iconColor: layerDesign.baseQuaternary,
                                    customIconSize: buttonSize * 0.5,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      );
}

/// Represents a button on the pin pad.
class PinButton extends Equatable {
  /// The title to show on the pin button.
  final String? title;

  /// The svg icon path to show instead of the title.
  /// Do not indicate the title if the button is going to show
  /// an svg asset.
  final String? svgPath;

  /// The callcack for when the button gets pressed.
  final VoidCallback onPressed;

  /// Whether if the button is visible or not.
  final bool visible;

  /// Whether if the button is enabled or not.
  final bool enabled;

  /// Creates a new [PinButton].
  PinButton({
    this.title,
    this.svgPath,
    required this.onPressed,
    this.visible = true,
    this.enabled = true,
  }) : assert(
          (title != null && title.isNotEmpty) ||
              (svgPath != null && svgPath.isNotEmpty),
          'Indicate only the title or the svgPath. '
          'The value should not be empty.',
        );

  @override
  List<Object?> get props => [
        title,
        svgPath,
        visible,
        enabled,
      ];
}
