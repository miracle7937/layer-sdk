import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';

import '../../dpa.dart';

/// Signature for [DPAHeader.customTitleBuilder].
typedef DPAHeaderTitleBuilder = Widget Function(
  BuildContext context,
  String? title,
);

/// The default Layer Design Kit header for the DPA.
///
/// It allows for some customization of the buttons and steps.
class DPAHeader extends StatelessWidget {
  /// The DPA process that governs this widget.
  final DPAProcess process;

  /// An optional back button to be used in place of the default
  /// [DPABackButton].
  final Widget? customBackButton;

  /// An optional builder to create the title widget instead of the default
  /// one.
  final DPAHeaderTitleBuilder? customTitleBuilder;

  /// An optional cancel button to be used in place of the default
  /// [DPACancelButton].
  final Widget? customCancelButton;

  /// If the steps should be shown.
  ///
  /// Defaults to `true`.
  final bool showSteps;

  /// An optional widget to display the steps to use in place of the default
  /// [DPANumberedSteps].
  ///
  /// Ignored if [showSteps] is `false`.
  final Widget? customSteps;

  /// The padding around the buttons and title.
  ///
  /// Defaults to [EdgeInsets.fromLTRB(32.0, 24.0, 33.0, 0.0)].
  final EdgeInsets headerPadding;

  /// The padding around the title text.
  ///
  /// Defaults to [EdgeInsets.only(left: 24.0, right: 10.0)].
  final EdgeInsets titlePadding;

  /// Creates a new [DPAHeader].
  const DPAHeader({
    Key? key,
    required this.process,
    this.customBackButton,
    this.customTitleBuilder,
    this.customCancelButton,
    this.showSteps = true,
    this.customSteps,
    this.headerPadding = const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
    this.titlePadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    final taskName = process.processName;

    // TODO: update with the correct Layer Design Kit implementation.
    final header = Row(
      children: [
        customBackButton ?? const DPABackButton(),
        Expanded(
          child: Padding(
            padding: titlePadding,
            child: customTitleBuilder?.call(context, taskName) ??
                Text(
                  taskName.isNotEmpty ? taskName : ' ',
                  style: layerDesign.titleL(),
                ),
          ),
        ),
        customCancelButton ?? const DPACancelButton(),
      ],
    );

    if (!showSteps) {
      return Padding(
        padding: headerPadding,
        child: header,
      );
    }

    return Padding(
      padding: headerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 16.0),
          customSteps ??
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DPANumberedSteps(),
              ),
        ],
      ),
    );
  }
}
