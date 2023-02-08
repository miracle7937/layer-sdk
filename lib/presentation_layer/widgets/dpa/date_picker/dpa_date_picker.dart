import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../layer_sdk.dart';

/// DPA Date Picker
class DPADatePicker extends StatefulWidget {
  /// DPA Variable
  final DPAVariable variable;

  /// Constructor for [DPADatePicker]
  const DPADatePicker({Key? key, required this.variable}) : super(key: key);

  @override
  _DPADatePickerState createState() => _DPADatePickerState();
}

class _DPADatePickerState extends State<DPADatePicker> {
  DateTime? dateValue;
  DateTime? maxDateTime;
  DateTime? minDateTime;
  late DPAProcessCubit cubit;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      cubit = context.read<DPAProcessCubit>();
      dateValue = widget.variable.value;
      if (widget.variable.constraints.maxDateTime != null) {
        maxDateTime = widget.variable.constraints.maxDateTime;
      }

      if (widget.variable.constraints.minDateTime != null) {
        minDateTime = widget.variable.constraints.minDateTime;
      }
      if (dateValue != null) {
        cubit.updateValue(variable: widget.variable, newValue: dateValue);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var label = widget.variable.label;
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);
    if (widget.variable.constraints.required) label = "$label*";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label != null && label.isNotEmpty
            ? Text(
                label,
                textAlign: TextAlign.start,
                style: design.titleS().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              )
            : SizedBox.shrink(),
        label != null && label.isNotEmpty
            ? SizedBox(height: 6)
            : SizedBox.shrink(),
        DKDateField(
          status: widget.variable.constraints.readonly
              ? DKTextFieldStatus.disabled
              : DKTextFieldStatus.idle,
          hint: widget.variable.property.hint,
          initialStartDate: dateValue,
          initialEndDate: maxDateTime,
          onStartDateChanged: (picked) {
            setState(() {
              cubit.updateValue(variable: widget.variable, newValue: picked);
              dateValue = picked;
            });
          },
          cancelButtonTitle: translation.translate('cancel'),
          saveButtonTitle: translation.translate('save'),
        ),
      ],
    );
  }
}
