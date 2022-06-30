import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits.dart';

/// A widget that displays the DPA step using the title and a line.
// TODO: make animated in the future
class DPALineStep extends StatelessWidget {
  /// The thickness of the line.
  ///
  /// Defaults to `2.0`.
  final double thickness;

  /// The optional color to use when painting the active steps.
  ///
  /// If not supplied, will default to [LayerDesign.brandPrimary].
  final Color? activeColor;

  /// The optional color to use when painting the inactive steps.
  ///
  /// If not supplied, will default to [LayerDesign.baseSeptenary].
  final Color? inactiveColor;

  /// Creates a new [DPALineStep].
  const DPALineStep({
    Key? key,
    this.thickness = 2.0,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);
    final state = context.watch<DPAProcessCubit>().state;

    return CustomPaint(
      size: Size(
        double.infinity,
        thickness,
      ),
      painter: _StepLinePainter(
        currentStep: state.activeProcess.step,
        totalSteps: state.activeProcess.stepCount,
        thickness: thickness,
        activeColor: activeColor ?? layerDesign.brandPrimary,
        inactiveColor: inactiveColor ?? layerDesign.surfaceSeptenary4,
      ),
    );
  }
}

class _StepLinePainter extends CustomPainter {
  final int currentStep;
  final int totalSteps;

  final double thickness;

  final Color activeColor;
  final Color inactiveColor;

  _StepLinePainter({
    required this.currentStep,
    required this.totalSteps,
    required this.thickness,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        thickness,
        size.width,
        thickness,
      ),
      Paint()
        ..color = inactiveColor
        ..style = PaintingStyle.fill,
    );

    if (totalSteps <= 0) return;

    canvas.drawRect(
      Rect.fromLTWH(
        0.0,
        thickness,
        (size.width * currentStep) / totalSteps,
        thickness,
      ),
      Paint()
        ..color = activeColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_StepLinePainter old) =>
      currentStep != old.currentStep ||
      totalSteps != old.totalSteps ||
      thickness != old.thickness ||
      activeColor != old.activeColor ||
      inactiveColor != old.inactiveColor;
}
