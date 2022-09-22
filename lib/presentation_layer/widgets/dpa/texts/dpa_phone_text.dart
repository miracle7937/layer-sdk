import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';
import '../../../utils.dart';

/// The DPA text field.
class DPAPhoneText extends StatefulWidget {
  /// The DPA variable that controls this widget.
  final DPAVariable variable;

  /// A custom padding to use.
  ///
  /// Default is [EdgeInsets.zero].
  final EdgeInsets padding;

  /// If the values can be changed.
  final bool readonly;

  /// Creates a new [DPAPhoneText]
  const DPAPhoneText({
    Key? key,
    required this.variable,
    this.padding = EdgeInsets.zero,
    required this.readonly,
  }) : super(key: key);

  @override
  _DPAPhoneTextState createState() => _DPAPhoneTextState();
}

class _DPAPhoneTextState extends State<DPAPhoneText> {
  TextEditingController? _controller;

  late String _selectedDialCode;

  @override
  void initState() {
    super.initState();

    if (!widget.variable.constraints.readonly) {
      _controller = TextEditingController(
        text: widget.variable.value?.toString(),
      );
    }

    _selectedDialCode = widget.variable.property.prefixValue ??
        widget.variable.property.defaultPrefix ??
        widget.variable.property.dialCodes.first.dialCode;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);

    return Padding(
      padding: widget.padding,
      child: DKPhoneField(
        searchFieldHint: Translation.of(context).translate('search'),
        initialSelection: _selectedDialCode,
        status: widget.readonly || widget.variable.constraints.readonly
            ? DKTextFieldStatus.disabled
            : DKTextFieldStatus.idle,
        controller: _controller,
        label: widget.variable.label,
        size: widget.variable.property.multiline
            ? DKTextFieldSize.multiline
            : DKTextFieldSize.large,
        warning: widget.variable.translateValidationError(translation),
        onCountryCodeChanged: (value) {
          _selectedDialCode = value;

          final phone = _controller?.text ?? '';

          if (phone.isNotEmpty) {
            context.read<DPAProcessCubit>().updateValue(
                  variable: widget.variable,
                  newValue: '$_selectedDialCode$phone',
                );
          }
        },
        countries: widget.variable.property.dialCodes
            .map(
              (dialCode) => DKPickerItem(
                title: dialCode.countryName,
                description: dialCode.countryCode,
                value: dialCode.dialCode,
                iconPath: DKFlags.countryFlag(
                  countryCode: dialCode.countryCode.toUpperCase(),
                ),
              ),
            )
            .toSet(),
        onChanged: (value) => context.read<DPAProcessCubit>().updateValue(
              variable: widget.variable,
              newValue: value.isEmpty ? '' : '$_selectedDialCode$value',
            ),
      ),
    );
  }
}
