import 'package:validators/validators.dart';

import '../../../models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [DPAValueDTO]
extension DPAValueDTOMapping on DPAValueDTO {
  /// Maps into a [DPAValue]
  DPAValue toDPAValue(DPAMappingCustomData customData) => DPAValue(
        id: id!,
        name: name!,
        icon: toCompleteIconUrl(customData),
        imageUrl: imageUrl,
        subName: subName,
        description: description,
        fields: fields?.toDPAValueFields() ?? [],
      );

  /// Checks if this [DPAValueDTO] has a valid URL and appends
  /// the base URL of the current environment configuration to it.
  ///
  /// Returns the original DTO object if the generated URL is invalid.
  String? toCompleteIconUrl(DPAMappingCustomData customData) {
    if (icon?.isEmpty ?? true) {
      return '';
    }

    if (customData.propertyType == DPAVariablePropertyType.countryPicker) {
      return icon;
    }

    final baseUrl = customData.fileBaseURL;
    final completeUrl = '$baseUrl/$icon';

    if (isURL(completeUrl)) {
      return completeUrl;
    }

    return icon;
  }
}

/// Extension that provides mappings for [DPAValue]
extension DPAValueMapping on DPAValue {
  /// Maps into a [DPAValueDTO]
  DPAValueDTO toDPAValueDTO() => DPAValueDTO(
        id: id,
        name: name,
        icon: icon,
        imageUrl: imageUrl,
        subName: subName,
        description: description,
      );
}

/// Extension that provides mapping for [DPAValueFieldDTO]
extension DPAValueFieldDTOMapping on DPAValueFieldDTO {
  /// Maps into a [DPAValueField]
  DPAValueField toDPAValueField() => DPAValueField(
        label: label ?? '',
        value: value,
      );
}

/// Extension that provides mappings for lists of [DPAValueDTO]
extension DPAValueDTOListMapping on List<DPAValueDTO> {
  /// Maps into a list of [DPAValue]
  List<DPAValue> toDPAValueList(DPAMappingCustomData customData) => map(
        (e) => e.toDPAValue(customData),
      ).toList();
}

/// Extension that provides mappings for lists of [DPAValue]
extension DPAValueListMapping on List<DPAValue> {
  /// Maps into a list of [DPAValueDTO]
  List<DPAValueDTO> toDPAValueDTOList() => map(
        (e) => e.toDPAValueDTO(),
      ).toList();
}

/// Extension that provides mappings for lists of [DPAValueFieldDTO]
extension DPAValueFieldListMappin on List<DPAValueFieldDTO> {
  /// Maps into a list of [DPAValueField]
  List<DPAValueField> toDPAValueFields() => map(
        (e) => e.toDPAValueField(),
      ).toList();
}
