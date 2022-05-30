import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../business_layer/business_layer.dart';
import '../../../../../../data_layer/data_layer.dart';

/// Shows the DPA steps as tabs, with the step number in a circle.
class DPANumberedSteps extends StatelessWidget {
  /// Creates a new [DPANumberedSteps].
  const DPANumberedSteps({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final process = context.select<DPAProcessCubit, DPAProcess>(
      (cubit) => cubit.state.activeProcess,
    );

    return NumberedSteps(
      currentStep: process.step,
      stepCount: process.stepCount,
      steps: process.properties?.steps ?? <String>[],
    );
  }
}

/// Widget that shows the steps of a process as tabs, with the step number in a
/// circle.
///
/// Mainly used by [DPANumberedSteps] for the DPA process.
// TODO: check if this is a good addition to the Design Kit.
class NumberedSteps extends StatelessWidget {
  /// The current step number. Indexed by 1.
  final int currentStep;

  /// The total number of steps.
  final int stepCount;

  /// If provided, gives the names of the steps to use on the tabs.
  ///
  /// If not provided, only the number of steps will be painted.
  final List<String> steps;

  /// Creates a new [NumberedSteps].
  const NumberedSteps({
    Key? key,
    required this.currentStep,
    required this.stepCount,
    this.steps = const <String>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    if (stepCount <= 0) return const SizedBox.shrink();

    return Row(
      children: List.generate(
        stepCount,
        (index) {
          final status = index + 1 == currentStep
              ? _StepStatus.current
              : index + 1 < currentStep
                  ? _StepStatus.previous
                  : _StepStatus.future;

          return _StepTab(
            stepStatus: status,
            number: index + 1,
            title: index < steps.length ? steps[index] : null,
            padding: const EdgeInsets.symmetric(
              horizontal: 17.0,
              vertical: 9.0,
            ),
            textStyle: layerDesign.bodyS(),
            backgroundColor: status.backgroundColor(layerDesign),
            borderColor: status.borderColor(layerDesign),
            titleTextColor: status.titleTextColor(layerDesign),
            circleColor: status.circleColor(layerDesign),
            stepColor: status.stepColor(layerDesign),
            stepWidget: status.stepWidget(layerDesign),
          );
        },
      ),
    );
  }
}

enum _StepStatus {
  previous,
  current,
  future,
}

class _StepTab extends ImplicitlyAnimatedWidget {
  final _StepStatus stepStatus;

  final int number;

  final String? title;

  final EdgeInsets padding;

  final TextStyle textStyle;

  final Color backgroundColor;
  final Color borderColor;
  final Color titleTextColor;
  final Color circleColor;
  final Color stepColor;

  final Widget? stepWidget;

  const _StepTab({
    Key? key,
    required this.stepStatus,
    required this.number,
    this.title,
    required this.padding,
    required this.textStyle,
    required this.backgroundColor,
    required this.borderColor,
    required this.titleTextColor,
    required this.circleColor,
    required this.stepColor,
    this.stepWidget,
    Curve curve = Curves.linear,
    Duration duration = const Duration(milliseconds: 500),
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );

  @override
  _StepTabState createState() => _StepTabState();
}

class _StepTabState extends AnimatedWidgetBaseState<_StepTab> {
  TextStyleTween? _textStyleTween;

  ColorTween? _backgroundColor;
  ColorTween? _borderColor;
  ColorTween? _titleTextColor;
  ColorTween? _circleColor;
  ColorTween? _stepColor;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = _textStyleTween?.evaluate(animation) ?? TextStyle();

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _backgroundColor?.evaluate(animation),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: _borderColor?.evaluate(animation) ?? Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _circleColor?.evaluate(animation) ?? Colors.transparent,
            ),
            child: SizedBox(
              width: 22.0,
              height: 22.0,
              child: AnimatedSwitcher(
                duration: widget.duration,
                child: widget.stepWidget ??
                    Text(
                      '${widget.number}',
                      key: ValueKey('step_${widget.number}'),
                      style: effectiveStyle.copyWith(
                        color: _stepColor?.evaluate(animation) ??
                            Colors.transparent,
                      ),
                      textHeightBehavior: TextHeightBehavior(
                        applyHeightToLastDescent: false,
                        applyHeightToFirstAscent: false,
                      ),
                    ),
              ),
            ),
          ),
          if (widget.title?.isNotEmpty ?? false) ...[
            const SizedBox(width: 7.0),
            Text(
              widget.title ?? '',
              style: effectiveStyle.copyWith(
                color: _titleTextColor?.evaluate(animation),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _textStyleTween = visitor(
      _textStyleTween,
      widget.textStyle,
      (dynamic value) => TextStyleTween(begin: value as TextStyle),
    ) as TextStyleTween;

    _backgroundColor = visitor(
      _backgroundColor,
      widget.backgroundColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;

    _borderColor = visitor(
      _borderColor,
      widget.borderColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;

    _titleTextColor = visitor(
      _titleTextColor,
      widget.titleTextColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;

    _circleColor = visitor(
      _circleColor,
      widget.circleColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;

    _stepColor = visitor(
      _stepColor,
      widget.stepColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween;
  }
}

extension on _StepStatus {
  /// The background color of the entire step tab.
  Color backgroundColor(LayerDesign layerDesign) {
    switch (this) {
      case _StepStatus.current:
        return layerDesign.surfaceNonary3;

      default:
        return layerDesign.surfaceNonary3.withOpacity(0.0);
    }
  }

  /// The color of the border around the entire step tab.
  Color borderColor(LayerDesign layerDesign) {
    switch (this) {
      case _StepStatus.current:
        return layerDesign.baseSenary;

      default:
        return layerDesign.baseSenary.withOpacity(0.0);
    }
  }

  /// The color of the step title
  Color titleTextColor(LayerDesign layerDesign) {
    switch (this) {
      case _StepStatus.previous:
        return layerDesign.successPrimary;

      case _StepStatus.current:
        return layerDesign.basePrimary;

      case _StepStatus.future:
        return layerDesign.baseTertiary;
    }
  }

  /// The color of the circle around the step number
  Color circleColor(LayerDesign layerDesign) {
    switch (this) {
      case _StepStatus.previous:
        return layerDesign.successTertiary;

      case _StepStatus.current:
        return layerDesign.baseSecondary;

      case _StepStatus.future:
        return layerDesign.surfaceSeptenary4;
    }
  }

  /// The color of the step number
  Color stepColor(LayerDesign layerDesign) {
    switch (this) {
      case _StepStatus.previous:
        return layerDesign.successPrimary;

      case _StepStatus.current:
        return layerDesign.basePrimaryWhite;

      case _StepStatus.future:
        return layerDesign.baseTertiary;
    }
  }

  Widget? stepWidget(LayerDesign layerDesign) {
    switch (this) {
      case _StepStatus.previous:
        return Center(
          child: SizedBox(
            width: 10.5,
            height: 9.0,
            child: CustomPaint(
              painter: _CheckPainter(
                color: layerDesign.successPrimary,
              ),
            ),
          ),
        );

      default:
        return null;
    }
  }
}

/// Draws a check used for previous steps
class _CheckPainter extends CustomPainter {
  final Color color;

  const _CheckPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(0.0, size.height / 2.0),
      Offset(size.width / 3.0, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3.0, size.height),
      Offset(size.width, 0.0),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.color != color;
}
