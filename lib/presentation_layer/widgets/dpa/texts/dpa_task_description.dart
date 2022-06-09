import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../../../domain_layer/models.dart';

/// Displays the DPA task description, if any.
class DPATaskDescription extends StatelessWidget {
  /// The DPA process that governs this widget.
  final DPAProcess process;

  /// The padding to use when there's a description to be displayed.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  /// Creates a [DPATaskDescription].
  const DPATaskDescription({
    Key? key,
    required this.process,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (process.task?.description?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final layerDesign = DesignSystem.of(context);

    final text = Text(
      process.task!.description!,
      style: layerDesign.bodyS(),
      textAlign: TextAlign.start,
    );

    if (padding == EdgeInsets.zero) return text;

    return Padding(
      padding: padding,
      child: text,
    );
  }
}
