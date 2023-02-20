import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../../layer_sdk.dart';

// TODO: Replace this widget with the design kit version of it.

/// Simple animated radio widget
class RadioButton<T> extends ImplicitlyAnimatedWidget {
  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// DBORadioButton<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T>? onChanged;

  /// If supplied, will paint this widget next to the button
  final Widget? titleWidget;

  /// If supplied, will paint the text next to the button.
  /// Will be ignored if [titleWidget] is provided
  final String? title;

  /// An optional text style to use when painting the title. If not
  /// supplied, will use the default style from DBO Figma.
  final TextStyle? titleStyle;

  /// The padding to add to the title. This is mainly used with the default
  /// values to separate the title from the radio.
  final EdgeInsets titlePadding;

  /// An optional callback to be called when the animation between states
  /// ends.
  final VoidCallback? onEndSwitch;

  /// Creates a new [RadioButton].
  const RadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.titleWidget,
    this.title,
    this.titleStyle,
    this.titlePadding = const EdgeInsets.only(left: 16.0),
    Curve curve = Curves.linear,
    Duration duration = const Duration(milliseconds: 200),
    this.onEndSwitch,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEndSwitch,
        );

  @override
  _DBORadioButtonState<T> createState() => _DBORadioButtonState<T>();
}

class _DBORadioButtonState<T> extends AnimatedWidgetBaseState<RadioButton<T>> {
  Tween<double>? _onOffValue;
  Tween<double>? _disabledValue;

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    Widget contents = SizedBox(
      width: 20.0,
      height: 20.0,
      child: CustomPaint(
        painter: _RadioButtonPainter(
          onOffValue: _onOffValue?.evaluate(animation) ?? 0.0,
          disabledValue: _disabledValue?.evaluate(animation) ?? 0.0,
          disabledColor: layerDesign.baseQuinary,
          activeColor: _onOffValue?.evaluate(animation) == 0
              ? layerDesign.baseQuinary
              : layerDesign.brandPrimary,
          backgroundColor: layerDesign.basePrimaryWhite,
          onGap: 5.5,
          offGap: 2.0,
        ),
      ),
    );

    if (widget.titleWidget != null) {
      contents = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          contents,
          Expanded(child: widget.titleWidget!),
        ],
      );
    } else if (widget.title != null) {
      contents = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          contents,
          Padding(
            padding: widget.titlePadding,
            child: Text(
              widget.title!,
              style: widget.titleStyle ?? layerDesign.titleM(),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: widget.onChanged != null
          ? () => widget.onChanged!(widget.value)
          : null,
      child: contents,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _onOffValue = visitor(
      _onOffValue,
      widget.value == widget.groupValue ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;

    _disabledValue = visitor(
      _disabledValue,
      widget.onChanged == null ? 0.0 : 1.0,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }
}

class _RadioButtonPainter extends CustomPainter {
  final double onOffValue;
  final double disabledValue;

  final Color disabledColor;
  final Color activeColor;
  final Color backgroundColor;

  final double onGap;
  final double offGap;

  _RadioButtonPainter({
    required this.onOffValue,
    required this.disabledValue,
    required this.disabledColor,
    required this.activeColor,
    required this.backgroundColor,
    required this.onGap,
    required this.offGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final circleCenter = Offset(
      size.width / 2.0,
      size.height / 2.0,
    );

    // Paint the on/off circle
    canvas.drawCircle(
      circleCenter,
      size.height / 2.0,
      Paint()
        ..color = Color.lerp(disabledColor, activeColor, disabledValue)!
        ..style = PaintingStyle.fill,
    );

    // Paint the background circle (yes, on top, as it's size is what
    // defines what is show of the on/off circle).
    canvas.drawCircle(
      circleCenter,
      lerpDouble(
        (size.height - (offGap * 2.0)) / 2.0,
        (size.height - (onGap * 2.0)) / 2.0,
        onOffValue,
      )!,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _RadioButtonPainter old) =>
      onOffValue != old.onOffValue ||
      disabledValue != old.disabledValue ||
      disabledColor != old.disabledColor ||
      activeColor != old.activeColor ||
      backgroundColor != old.backgroundColor ||
      onGap != old.onGap ||
      offGap != old.offGap;
}
