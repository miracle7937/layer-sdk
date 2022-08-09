import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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

  /// Whether the widget is used on the popup task. Defaults to false.
  final bool forPopup;

  /// Creates a new [DPAText]
  const DPAText({
    Key? key,
    required this.variable,
    this.readonly = false,
    this.forPopup = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  _DPATextState createState() => _DPATextState();
}

class _DPATextState extends State<DPAText> {
  TextEditingController? _controller;

  bool get _characterSplit =>
      (widget.variable.property.characterSplit ?? false);

  @override
  void initState() {
    super.initState();

    if (_characterSplit || !widget.variable.constraints.readonly) {
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
    final layerDesign = DesignSystem.of(context);

    final List<String> listOfLetters =
        (widget.variable.value ?? '').trim().split("");
    final length = widget.variable.constraints.readonly
        ? listOfLetters.isEmpty
            ? (widget.variable.constraints.maxLength ?? 0)
            : listOfLetters.length
        : (widget.variable.constraints.maxLength ?? 0);

    if (_characterSplit && length == 0) {
      //Invalid response from automation
      return SizedBox.shrink();
    }

    return Padding(
      padding: widget.padding,
      child: _characterSplit
          ? SizedBox(
              width: widget.forPopup && length <= 4 ? 230 : null,
              child: PinCodeTextField(
                enabled:
                    !(widget.readonly || widget.variable.constraints.readonly),
                appContext: context,
                length: length,
                boxShadows: [
                  BoxShadow(
                    color: layerDesign.surfaceSeptenary4,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                  BoxShadow(
                    color: layerDesign.surfaceSeptenary4,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
                onChanged: (v) => context.read<DPAProcessCubit>().updateValue(
                      variable: widget.variable,
                      newValue: v,
                    ),
                textStyle: layerDesign.bodyXXL(),
                controller: _controller,
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                autoDisposeControllers: false,
                enablePinAutofill: true,
                pinTheme: PinTheme(
                  fieldWidth: length <= 6 ? 52 : 38,
                  fieldHeight: length <= 6 ? 52 : 38,
                  borderRadius: BorderRadius.circular(12),
                  borderWidth: 1,
                  disabledColor: layerDesign.basePrimaryWhite,
                  activeColor: layerDesign.basePrimaryWhite,
                  activeFillColor: layerDesign.basePrimaryWhite,
                  fieldOuterPadding: widget.forPopup
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: 3),
                  inactiveColor: layerDesign.basePrimaryWhite,
                  selectedColor: layerDesign.brandPrimary,
                  inactiveFillColor: layerDesign.basePrimaryWhite,
                  selectedFillColor: layerDesign.basePrimaryWhite,
                  shape: PinCodeFieldShape.box,
                ),
              ),
            )
          : widget.readonly || widget.variable.constraints.readonly
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
                  warning:
                      widget.variable.translateValidationError(translation),
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
    final currency = widget.variable.property.currencyFlagCode;
    final valueTextProperties = widget.variable.property.valueTextProperties;

    return (labelTextProperties?.textStyle == DPAVariableTextStyle.titleXXL &&
            (label?.isNotEmpty ?? false))
        ? Center(
            child: Text(label!,
                style: labelTextProperties?.toTextStyle(
                      layerDesign,
                    ) ??
                    layerDesign.bodyS(
                      color: labelTextProperties?.flutterColor ??
                          layerDesign.baseQuaternary,
                    )),
          )
        : Column(
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
              if (value?.isNotEmpty ?? false || (currency?.isNotEmpty ?? false))
                Row(children: [
                  if (currency?.isNotEmpty ?? false) ...[
                    Image.asset(
                      'icons/currency/${currency!.toLowerCase()}.png',
                      width: 24,
                      height: 18,
                      package: 'currency_icons',
                      errorBuilder: (context, object, stackTrace) =>
                          Container(width: 24),
                    ),
                    SizedBox(width: 8)
                  ],
                  if (value?.isNotEmpty ?? false)
                    Expanded(
                      child: Text(value!.toString(),
                          style: valueTextProperties?.toTextStyle(
                                layerDesign,
                              ) ??
                              layerDesign.bodyM(
                                color: valueTextProperties?.flutterColor,
                              )),
                    ),
                ])
            ],
          );
  }
}
