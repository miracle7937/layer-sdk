import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';
import '../../../utils.dart';

/// The DPA text field.
class DPAText extends StatefulWidget {
  /// The DPA variable that controls this widget.
  final DPAVariable variable;

  /// If the values can be changed.
  final bool readonly;

  /// A custom padding to use.
  ///
  /// Default is [EdgeInsets.zero].
  final EdgeInsets padding;

  /// Creates a new [DPAText]
  const DPAText({
    Key? key,
    required this.variable,
    this.readonly = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _DPATextState createState() => _DPATextState();
}

class _DPATextState extends State<DPAText> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    if (!widget.variable.constraints.readonly) {
      _controller = TextEditingController(
        text: widget.variable.value?.toString(),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);

    return Padding(
      padding: widget.padding,
      child: widget.readonly || widget.variable.constraints.readonly
          ? _buildReadOnlyWidget(design)
          : DKTextField(
              status: DKTextFieldStatus.idle,
              controller: _controller,
              label: widget.variable.label,
              obscureText: widget.variable.property.isPassword,
              maxLength: widget.variable.constraints.maxLength,
              keyboardType: widget.variable.toTextInputType(),
              size: widget.variable.property.multiline
                  ? DKTextFieldSize.multiline
                  : DKTextFieldSize.large,
              warning: widget.variable.translateValidationError(translation),
              keepWarningSize: true,
              inputFormatters: widget.variable.toTextInputFormatters(),
              onChanged: (v) => context.read<DPAProcessCubit>().updateValue(
                    variable: widget.variable,
                    newValue: v,
                  ),
            ),
    );
  }

  /// Builds the variant where the [DPAVariable] is a plain text.
  Widget _buildReadOnlyWidget(
    LayerDesign layerDesign,
  ) {
    final label = widget.variable.label;
    final labelTextProperties = widget.variable.property.labelTextProperties;

    final value = widget.variable.value;
    final valueTextProperties = widget.variable.property.valueTextProperties;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label?.isNotEmpty ?? false) ...[
          Text(
            label!,
            style: labelTextProperties?.toTextStyle(
                  layerDesign,
                ) ??
                layerDesign.bodyS(
                  color: labelTextProperties?.flutterColor ??
                      layerDesign.baseQuaternary,
                ),
          ),
          const SizedBox(height: 2.0),
        ],
        if (value?.isNotEmpty ?? false)
          Text(
            value!.toString(),
            style: valueTextProperties?.toTextStyle(
                  layerDesign,
                ) ??
                layerDesign.bodyM(
                  color: valueTextProperties?.flutterColor,
                ),
          ),
      ],
    );
  }
}
