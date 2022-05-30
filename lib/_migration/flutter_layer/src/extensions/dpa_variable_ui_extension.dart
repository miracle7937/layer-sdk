import 'package:flutter/services.dart';
import '../../../data_layer/data_layer.dart';

import '../utils.dart';

/// UI Extension for [DPAVariable]
extension DPAVariableUIExtension on DPAVariable {
  /// Returns the translation associated with the error
  String? translateValidationError(
    Translation translation, {
    String? dropdownValidatioKey,
    String? uploadValidationKey,
    String? textFieldValidationKey,
  }) {
    switch (validationError) {
      case DPAValidationError.required:
        return translation.translate(
          type == DPAVariableType.dropdown
              ? dropdownValidatioKey ?? 'select_item'
              : type.shouldUploadFile
                  ? uploadValidationKey ?? 'please_attach_document'
                  : textFieldValidationKey ?? 'cannot_be_blank',
        );

      case DPAValidationError.minLength:
        return translation
            .translate('text_too_short')
            .replaceAll('{value}', '${constraints.minLength}');

      case DPAValidationError.maxLength:
        return translation
            .translate('text_too_long')
            .replaceAll('{value}', '${constraints.maxLength}');

      case DPAValidationError.minValue:
        return translation
            .translate('value_too_low')
            .replaceAll('{value}', '${constraints.minValue}');

      case DPAValidationError.maxValue:
        return translation
            .translate('value_too_high')
            .replaceAll('{value}', '${constraints.maxValue}');

      case DPAValidationError.format:
        return translation.translate('invalid_format');

      default:
        return null;
    }
  }

  /// Return the [TextInputType] that best represents this variable.
  TextInputType toTextInputType() {
    // TODO: try to match with the other types of TextInputType
    if (type == DPAVariableType.number ||
        property.keyboard == DPAVariableKeyboard.numeric) {
      return TextInputType.number;
    }

    if (property.multiline) return TextInputType.multiline;

    return TextInputType.text;
  }

  /// Returns a list of [TextInputFormatter] that enforce the constraints
  /// and other properties for this variable.
  List<TextInputFormatter> toTextInputFormatters() {
    final formatters = <TextInputFormatter>[];

    if (type == DPAVariableType.number ||
        property.keyboard == DPAVariableKeyboard.numeric) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (constraints.regExp != null) {
      formatters.add(
        FilteringTextInputFormatter.allow(constraints.regExp!),
      );
    }

    if (constraints.maxLength != null) {
      formatters.add(
        LengthLimitingTextInputFormatter(constraints.maxLength),
      );
    }

    return formatters;
  }
}
