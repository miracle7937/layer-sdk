import 'package:collection/collection.dart';
import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../data_layer/dtos.dart';
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

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// The description of the text field
  ///
  /// In case of null no description will be displayed
  final String? description;

  /// Whether the widget keelps the warning size
  ///
  /// Defaults to `true`
  final bool keepWarningSize;

  /// The configs for the obscure functionality.
  /// This will have effects only when [isPassword] property is true.
  final ObscureConfigs obscureConfigs;

  /// Creates a new [DPAText]
  const DPAText({
    Key? key,
    required this.variable,
    this.readonly = false,
    this.forPopup = false,
    this.padding = EdgeInsets.zero,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.description,
    this.keepWarningSize = true,
    this.obscureConfigs = const ObscureConfigs(),
  }) : super(key: key);

  @override
  _DPATextState createState() => _DPATextState();
}

class _DPATextState extends State<DPAText> {
  TextEditingController? _controller;

  bool get _characterSplit =>
      (widget.variable.property.characterSplit ?? false);

  bool get _userControlsObscure =>
      widget.variable.property.isPassword &&
      widget.obscureConfigs.userControlsObscure;

  late bool _textObscured;

  @override
  void initState() {
    super.initState();

    _textObscured = widget.variable.property.isPassword;

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
                  obscureText: _textObscured,
                  maxLength: widget.variable.constraints.maxLength,
                  keyboardType: widget.variable.toTextInputType(),
                  size: widget.variable.property.multiline
                      ? DKTextFieldSize.multiline
                      : DKTextFieldSize.large,
                  warning:
                      widget.variable.translateValidationError(translation),
                  keepWarningSize: widget.keepWarningSize,
                  inputFormatters: widget.variable.toTextInputFormatters(),
                  onChanged: (v) => context.read<DPAProcessCubit>().updateValue(
                        variable: widget.variable,
                        newValue: v,
                      ),
                  scrollPadding: widget.scrollPadding,
                  description: widget.description,
                  suffixIconPath: _userControlsObscure
                      ? _textObscured
                          ? widget.obscureConfigs.obscuredIconPath
                          : widget.obscureConfigs.unObscuredIconPath
                      : null,
                  onSuffixIconPressed: _userControlsObscure
                      ? () => setState(() => _textObscured = !_textObscured)
                      : null,
                ),
    );
  }

  /// Builds the variant where the [DPAVariable] is a plain text.
  Widget _buildReadOnlyWidget(
    LayerDesign layerDesign,
  ) {
    final label = widget.variable.label;
    final icon = widget.variable.property.iconUrl;
    final labelColorRaw = widget.variable.property.labelColor;
    final labelFontRaw = widget.variable.property.labelFontStyle;
    final labelFont = DPAVariableTextStyleDTO.fromRaw(labelFontRaw);
    final fontTextStyle = DPAVariableTextStyle.values.firstWhereOrNull(
        (element) => element.name == (labelFont?.value ?? ''));
    final iconProperties = DPAVariableTextProperties(
        color: labelColorRaw, textStyle: fontTextStyle);
    final labelTextProperties = widget.variable.property.labelTextProperties;
    final value = widget.variable.value;
    final flagPath =
        (widget.variable.property.currencyFlagCode ?? '').currencyOrCountryFlag;
    final valueTextProperties = widget.variable.property.valueTextProperties;

    return (labelTextProperties?.textStyle == DPAVariableTextStyle.titleXXL &&
            (label?.isNotEmpty ?? false))
        ? Center(
            child: Text(
              label!,
              style: labelTextProperties?.toTextStyle(
                    layerDesign,
                  ) ??
                  layerDesign.bodyS(
                    color: labelTextProperties?.flutterColor ??
                        layerDesign.baseQuaternary,
                  ),
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label?.isNotEmpty ?? false) ...[
                Row(
                  children: [
                    if (icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          color: layerDesign.surfaceNonary3,
                          border: Border.all(
                            color: layerDesign.surfaceSeptenary4,
                          ),
                        ),
                        child: Text(
                          icon,
                          style: iconProperties.toTextStyle(
                            layerDesign,
                          ),
                        ),
                      ),
                      SizedBox(width: 12)
                    ],
                    Expanded(
                      child: Text(
                        label!,
                        style: labelTextProperties?.toTextStyle(
                              layerDesign,
                            ) ??
                            layerDesign.bodyS(
                              color: labelTextProperties?.flutterColor ??
                                  layerDesign.baseQuaternary,
                            ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 2.0),
              ],
              if (value?.isNotEmpty ?? false || (flagPath?.isNotEmpty ?? false))
                Row(children: [
                  if (flagPath?.isNotEmpty ?? false) ...[
                    SvgPicture.asset(
                      flagPath!,
                      width: 24,
                      height: 18,
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

/// This class holds the configurations of the user manual obscure functionality
class ObscureConfigs {
  /// Whether the use can control showing/hiding (obscure/un-obscure) the
  /// content of the [DPAText] when [isPassword] is true
  ///
  /// Defaults to `false`
  final bool userControlsObscure;

  /// The icon that shows when the password is obscured
  final String? obscuredIconPath;

  /// The icon that shows when the password is un-obscured
  final String? unObscuredIconPath;

  /// Create a new instance of [ObscureConfigs]
  const ObscureConfigs({
    this.userControlsObscure = false,
    this.obscuredIconPath,
    this.unObscuredIconPath,
  }) : assert(
          !userControlsObscure ||
              (obscuredIconPath != null && unObscuredIconPath != null),
          "When userControlsObscure is enabled, obscuredIconPath and"
          "unObscuredIconPath cannot be null",
        );
}
