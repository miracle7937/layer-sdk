import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';

/// Simple animated switch widget for the DPA.
class DPASwitch extends StatelessWidget {
  /// The DPA variable that controls this widget.
  final DPAVariable variable;

  /// If the values can be changed.
  final bool readonly;

  /// Creates a new
  const DPASwitch({
    Key? key,
    required this.variable,
    this.readonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    final value = variable.value as bool? ?? false;
    final label = variable.label ?? '';

    return Row(
      children: [
        DKSwitch(
          value: value,
          onChanged: (v) => context.read<DPAProcessCubit>().updateValue(
                variable: variable,
                newValue: v,
              ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Text(
            label,
            style: layerDesign.bodyM(),
            maxLines: 10,
          ),
        ),
      ],
    );
  }
}
