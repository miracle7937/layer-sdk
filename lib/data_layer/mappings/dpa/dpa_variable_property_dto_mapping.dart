import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [DPAVariablePropertyDTO]
extension DPAVariablePropertyDTOMapping on DPAVariablePropertyDTO {
  /// Maps into a [DPAVariableProperty]
  DPAVariableProperty toDPAVariableProperty(DPAMappingCustomData customData) =>
      DPAVariableProperty(
        link: link,
        step: step == null ? null : int.tryParse(step!),
        display: display,
        help: help,
        keyboard: keyboard?.toDPAVariableKeyboard() ?? DPAVariableKeyboard.text,
        decimals: decimals,
        errorMessage: errorMessage,
        encrypt: encrypt ?? false,
        isPassword: isPassword ?? false,
        searchBar: searchBar ?? false,
        multiline: [
              PropertyTypeDTO.textArea,
              PropertyTypeDTO.textView,
            ].contains(propertyType) ||
            [
              DPAFormatDTO.textArea,
            ].contains(format),
        multipleValues: multipleValues ?? false,
        labelType:
            labelType?.toDPAVariableLabelType() ?? DPAVariableLabelType.regular,
        hint: hint,
        prefix: prefix,
        icon: icon,
        type: propertyType?.toDPAVariablePropertyType(),
        allowedTypes: allowedTypes,
        image: image == null ? null : '${customData.fileBaseURL}$image',
        dialCodes: dialCodes?.map((e) => e.toDialCode()).toList() ?? [],
        prefixValue: prefixValue,
        description: description,
        labelTextProperties: labelTextProperties?.toTextProperties(),
        valueTextProperties: valueTextProperties?.toTextProperties(),
        currencyFlagCode: currencyFlagCode,
        characterSplit: characterSplit,
        picker: picker?.toDPAVariablePicker() ?? DPAVariablePicker.currency,
        defaultPrefix: defaultPrefix,
      );
}

/// Extension that provides mappings for [KeyboardDTO].
extension KeyboardDTOMapping on KeyboardDTO {
  /// Maps into a [DPAVariableKeyboard].
  DPAVariableKeyboard toDPAVariableKeyboard() {
    switch (this) {
      case KeyboardDTO.text:
        return DPAVariableKeyboard.text;

      case KeyboardDTO.numeric:
        return DPAVariableKeyboard.numeric;

      default:
        throw MappingException(
          from: KeyboardDTO,
          to: DPAVariableKeyboard,
          value: this,
        );
    }
  }
}

/// Extension that provides mappings for [PickerDTO].
extension PickerDTOMapping on PickerDTO {
  /// Maps into a [DPAVariablePicker].
  DPAVariablePicker toDPAVariablePicker() {
    switch (this) {
      case PickerDTO.currency:
        return DPAVariablePicker.currency;
      default:
        throw MappingException(
          from: PickerDTO,
          to: DPAVariablePicker,
          value: this,
        );
    }
  }
}

/// Extension that provides mappings for [DPALabelTypeDTO].
extension DPALabelTypeDTOMapping on DPALabelTypeDTO {
  /// Maps into a [DPAVariableLabelType].
  DPAVariableLabelType toDPAVariableLabelType() {
    switch (this) {
      case DPALabelTypeDTO.regular:
        return DPAVariableLabelType.regular;

      case DPALabelTypeDTO.bold:
        return DPAVariableLabelType.bold;

      default:
        throw MappingException(
          from: DPALabelTypeDTO,
          to: DPAVariableLabelType,
          value: this,
        );
    }
  }
}

/// Extension that provides mappings for [PropertyTypeDTO].
extension PropertyTypeDTOMapping on PropertyTypeDTO {
  /// Maps into a [DPAVariablePropertyType].
  DPAVariablePropertyType? toDPAVariablePropertyType() {
    switch (this) {
      case PropertyTypeDTO.searchResults:
        return DPAVariablePropertyType.searchResults;

      case PropertyTypeDTO.countryPicker:
        return DPAVariablePropertyType.countryPicker;

      default:
        return null;
    }
  }
}

/// Extension that provides mapping for [DPAVariableProperty]
extension DPAVariablePropertyMapping on DPAVariableProperty {
  /// Maps into a [DPAVariablePropertyDTO]
  DPAVariablePropertyDTO toDPAVariablePropertyDTO() => DPAVariablePropertyDTO(
        propertyType: type?.toPropertyTypeDTO(),
      );
}

/// Extension that provides mapping for [DPAVariablePropertyType]
extension DPAVariablePropertyTypeMapping on DPAVariablePropertyType {
  /// Maps into a [PropertyTypeDTO]
  PropertyTypeDTO? toPropertyTypeDTO() {
    switch (this) {
      case DPAVariablePropertyType.searchResults:
        return PropertyTypeDTO.searchResults;

      default:
        return null;
    }
  }
}

/// Extension that provides mappings for [DPADialCodeDTO].
extension DPADialCodeDTOMapping on DPADialCodeDTO {
  /// Maps into a [DPADialCode].
  DPADialCode toDialCode() => DPADialCode(
        countryCode: countryCode ?? '',
        countryName: countryName ?? '',
        dialCode: dialCode ?? '',
      );
}
