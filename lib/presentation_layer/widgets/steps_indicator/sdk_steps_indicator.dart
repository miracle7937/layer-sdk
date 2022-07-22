import 'package:flutter/material.dart';

/// A widget that shows a representation of the progress in a flow
/// with the completed steps colored and the remaining steps disabled.
class SDKStepsIndicator extends StatelessWidget {
  /// The current step.
  final int currentStep;

  /// The total amount of steps.
  final int stepsCount;

  /// Creates a new [SDKStepsIndicator].
  const SDKStepsIndicator({
    Key? key,
    required this.currentStep,
    required this.stepsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Wrap(),
      );
}
