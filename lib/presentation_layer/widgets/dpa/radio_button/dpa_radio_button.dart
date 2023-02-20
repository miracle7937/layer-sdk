import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/dpa.dart';
import '../../../../layer_sdk.dart';
import '../label/dpa_label.dart';
import 'radio_button.dart';

/// The DPA radio buttons for the design.
class DPARadioButton extends StatelessWidget {
  /// The DPA variable that controls this widget.
  final DPAVariable variable;

  /// If the values can be changed.
  final bool readonly;

  /// Creates a new [DPARadioButton].
  const DPARadioButton({
    Key? key,
    required this.variable,
    required this.readonly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DPALabel(variable: variable),
        ...variable.availableValues
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: RadioButton(
                  titleWidget: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      e.name,
                      style: layerDesign.titleM(),
                    ),
                  ),
                  value: e.id,
                  groupValue: variable.value,
                  onChanged: readonly || variable.constraints.readonly
                      ? null
                      : (v) => context.read<DPAProcessCubit>().updateValue(
                            variable: variable,
                            newValue: v,
                          ),
                ),
              ),
            )
            .toList(growable: false),
      ],
    );
  }
}
