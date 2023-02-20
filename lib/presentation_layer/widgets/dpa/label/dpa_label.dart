import 'package:flutter/material.dart';
import 'package:layer_sdk/layer_sdk.dart';

/// A simple label for the DPA widgets.
class AkornDPALabel extends StatelessWidget {
  /// The DPA variable to show the label for.
  final DPAVariable variable;

  /// A custom padding to use.
  final EdgeInsets padding;

  /// Creates a new [AkornDPALabel].
  const AkornDPALabel({
    Key? key,
    required this.variable,
    this.padding = const EdgeInsets.all(4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (variable.label?.isEmpty ?? true) {
      return Padding(
        padding: EdgeInsets.only(top: padding.top),
        child: const SizedBox.shrink(),
      );
    }

    final layerDesign = DesignSystem.of(context);

    return Padding(
      padding: padding,
      child: Text(
        variable.label!,
        style: layerDesign.titleS(
          color: variable.constraints.readonly ? layerDesign.basePrimary : null,
        ),
      ),
    );
  }
}
