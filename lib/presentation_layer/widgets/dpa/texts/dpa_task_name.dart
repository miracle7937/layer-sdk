import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../../../domain_layer/models.dart';

/// Displays the DPA task name, if any.
class DPATaskName extends StatelessWidget {
  /// The DPA process that governs this widget.
  final DPAProcess process;

  /// The padding to use when there's a name to be displayed.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  /// Creates a [DPATaskName].
  const DPATaskName({
    Key? key,
    required this.process,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (process.task?.name.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final layerDesign = DesignSystem.of(context);

    final text = Text(
      process.task!.name,
      style: layerDesign.titleXL(),
    );

    if (padding == EdgeInsets.zero) return text;

    return Padding(
      padding: padding,
      child: text,
    );
  }
}
