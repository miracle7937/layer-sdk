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

  /// The dpa variable.
  late DPAVariable _variable;
  DPAVariable get variable => _variable;
  set variable(DPAVariable variable) => setState(() => _variable = variable);

  @override
  void initState() {
    super.initState();

    _variable = widget.variable;

    if (!variable.constraints.readonly) {
      _controller = TextEditingController(
        text: variable.value?.toString(),
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
      child: widget.readonly || variable.constraints.readonly
          ? _buildReadOnlyWidget(design)
          : DKTextField(
              status: DKTextFieldStatus.idle,
              controller: _controller,
              label: variable.label,
              obscureText: variable.property.isPassword,
              maxLength: variable.constraints.maxLength,
              keyboardType: variable.toTextInputType(),
              size: variable.property.multiline
                  ? DKTextFieldSize.multiline
                  : DKTextFieldSize.large,
              warning: variable.translateValidationError(translation),
              keepWarningSize: true,
              inputFormatters: variable.toTextInputFormatters(),
              onChanged: (v) => context.read<DPAProcessCubit>().updateValue(
                    variable: variable,
                    newValue: v,
                  ),
            ),
    );
  }

  Widget _buildReadOnlyWidget(LayerDesign layerDesign) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((variable.label ?? '').isNotEmpty) ...[
            Text(
              variable.label!,
              style: variable.property.textProperties?.toTextStyle(
                    layerDesign,
                  ) ??
                  layerDesign.bodyS(
                    color: layerDesign.baseQuaternary,
                  ),
            ),
            const SizedBox(height: 2.0),
          ],
          if (variable.value != null)
            Text(
              variable.value!.toString(),
              style: layerDesign.bodyM(),
            ),
        ],
      );
}
