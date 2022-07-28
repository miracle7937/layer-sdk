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
class PinPadView extends StatelessWidget {
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
  }) : assert(!showBiometrics || onBiometrics != null);

  /// The buttons that will appear on the pin pad.
  List<PinButton> pinButtons(BuildContext context) {
    final translation = Translation.of(context);

    return [
      ...List.generate(
        9,
        (index) {
          final number = (index + 1).toString();

          return PinButton(
            title: number,
            onPressed: () => onChanged('$pin$number'),
            enabled: pin.length < pinLenght,
          );
        },
      ),
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
            onBiometrics!();
          }
        },
        enabled: showBiometrics,
        visible: showBiometrics,
      ),
      PinButton(
        title: '0',
        onPressed: () => onChanged('${pin}0'),
        enabled: pin.length < pinLenght,
      ),
      PinButton(
        svgPath: FLImages.backspace,
        onPressed: () => onChanged(
          pin.substring(0, pin.length - 1),
        ),
        enabled: pin.isNotEmpty,
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
          ignoring: disabled,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 16.0,
            ),
            child: Column(
              children: [
                Container(
                  child: AutoSizeText(
                    title,
                    textAlign: TextAlign.center,
                    style: layerDesign.bodyM(),
                    maxLines: 3,
                    presetFontSizes: [16.0, 13.0, 10.0],
                  ),
                ),
                const SizedBox(height: 90.0),
                _buildPinDotsIndicator(layerDesign),
                const SizedBox(height: 70.0),
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
      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pinLenght,
              (index) => IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DKRadioButton(
                    selected: pin.length > index,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: warning == null
                  ? Container()
                  : Transform.translate(
                      offset: Offset(0.0, 30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            warning!,
                            style: layerDesign.bodyS(
                              color: layerDesign.errorPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                    child: Row(
                      mainAxisAlignment: _calculateButtonAlignment(
                        context,
                        button,
                      ),
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final buttonSize =
                                constraints.maxHeight > constraints.maxWidth
                                    ? constraints.maxWidth
                                    : constraints.maxHeight;

                            return SizedBox(
                              height: buttonSize,
                              width: buttonSize,
                              child: IgnorePointer(
                                ignoring: !button.enabled,
                                child: Visibility(
                                  visible: button.visible,
                                  maintainAnimation: true,
                                  maintainSize: true,
                                  maintainState: true,
                                  child: button.svgPath == null
                                      ? DKButton(
                                          title: button.title!,
                                          onPressed: button.onPressed,
                                          type: DKButtonType.baseSecondary,
                                          shape: BoxShape.circle,
                                          customTextStyle:
                                              layerDesign.titleXXXL().copyWith(
                                                    height: 1,
                                                    fontSize: buttonSize * 0.3,
                                                  ),
                                        )
                                      : DKButton.icon(
                                          iconPath: button.svgPath!,
                                          onPressed: button.onPressed,
                                          type: DKButtonType.basePlain,
                                          shape: BoxShape.circle,
                                          iconColor: layerDesign.baseQuaternary,
                                          customIconSize: 40.0,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      );

  /// Calculates the [MainAxisAlignment] of the pin buttons in the wrap.
  ///
  /// If the button is first in the row the alignemnt will be
  /// [MainAxisAlignment.end], if it's las in the row, the alignment will be
  /// [MainAxisAlignment.start], otherwise the alignment will be
  /// [MainAxisAlignment.center].
  MainAxisAlignment _calculateButtonAlignment(
    BuildContext context,
    PinButton button,
  ) {
    final firstInRowItems = [0, 3, 6, 9];
    final lastInRowItems = [2, 5, 8, 11];

    for (final item in firstInRowItems) {
      if (pinButtons(context).elementAt(item) == button) {
        return MainAxisAlignment.end;
      }
    }

    for (final item in lastInRowItems) {
      if (pinButtons(context).elementAt(item) == button) {
        return MainAxisAlignment.start;
      }
    }

    return MainAxisAlignment.center;
  }
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
