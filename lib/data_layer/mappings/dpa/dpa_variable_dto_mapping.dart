import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../extensions.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [DPAVariableDTO]
extension DPAVariableDTOMapping on DPAVariableDTO {
  /// Maps into a [DPAVariable]
  DPAVariable toDPAVariable(DPAMappingCustomData customData) {
    final type = toDPAVariableType();
    final dpaVariableProperty = property?.toDPAVariableProperty(customData);
    final availableValues = values?.toDPAValueList(
          customData.copyWith(
            propertyType: dpaVariableProperty?.type,
          ),
        ) ??
        [];

    final variable = DPAVariable(
      id: id ?? '',
      key: key ?? '',
      constraints: constraints == null
          ? DPAConstraint()
          : constraints!.toDPAConstraint(property),
      label: label,
      order: order,
      type: type,
      submitType: submitType ?? 'string',
      value: type == DPAVariableType.dateTime
          ? DateTimeConverter.fromDTOString(value)
          : (type == DPAVariableType.dropdown ||
                  type == DPAVariableType.listButton)
              ? _toDropdownValue(
                  dtoValue: value,
                  availableValues: availableValues,
                )
              : value,
      availableValues: availableValues,
      property: dpaVariableProperty ?? DPAVariableProperty(),
      extraInformation: valueInfo ?? '',
    );

    return variable.type.shouldUploadFile && value != null
        ? _toFileVariable(variable)
        : variable.type == DPAVariableType.link
            ? _toLinkVariable(variable, customData)
            : variable;
  }

  /// Maps into a [DPAVariableType].
  DPAVariableType toDPAVariableType() {
    switch (type) {
      case DPATypeDTO.string:
        if (property?.format == DPAFormatDTO.pin) {
          return DPAVariableType.pin;
        }

        if (property?.format == DPAFormatDTO.textArea) {
          return DPAVariableType.textArea;
        }

        if (property?.link != null) {
          return DPAVariableType.link;
        }

        if (property?.format == DPAFormatDTO.image) {
          if (property?.propertyType == PropertyTypeDTO.signature) {
            return DPAVariableType.signature;
          }

          return DPAVariableType.image;
        }

        if (property?.propertyType == PropertyTypeDTO.swipe) {
          return DPAVariableType.swipe;
        }

        return DPAVariableType.text;

      case DPATypeDTO.long:
        if (property?.propertyType == PropertyTypeDTO.longSlider) {
          return DPAVariableType.numberSlider;
        }
        return DPAVariableType.number;

      case DPATypeDTO.boolean:
        return DPAVariableType.boolean;

      case DPATypeDTO.date:
        return DPAVariableType.dateTime;

      case DPATypeDTO.enumType:
        if (property?.propertyType == PropertyTypeDTO.horizontalList) {
          return DPAVariableType.horizontalPicker;
        }

        if (property?.propertyType == PropertyTypeDTO.radioButton) {
          return DPAVariableType.radioButton;
        }

        if (property?.propertyType == PropertyTypeDTO.listButton) {
          return DPAVariableType.listButton;
        }

        if (property?.propertyType == PropertyTypeDTO.switchType) {
          return DPAVariableType.toggleList;
        }

        return DPAVariableType.dropdown;

      case DPATypeDTO.searchResults:
        return DPAVariableType.searchResults;

      default:
        Logger('DPATypeDTOMapping').warning(
          MappingException(from: DPATypeDTO, to: DPAVariableType).toString(),
        );

        return DPAVariableType.unknown;
    }
  }

  DPAVariable _toLinkVariable(
    DPAVariable variable,
    DPAMappingCustomData customData,
  ) {
    final String text = variable.value ?? '';

    final startIndex = text.indexOf('<l>');
    final endIndex = text.indexOf('</l>');

    if (startIndex == -1 || endIndex == -1) {
      return variable.copyWith(
        value: DPALinkData(
          beforeLink: text,
          link: '',
          afterLink: '',
          originalText: '',
        ),
      );
    }

    final beforeLink = text.split('<l>').first;

    return variable.copyWith(
      value: DPALinkData(
        beforeLink: beforeLink,
        link: text.substring(startIndex + 3, endIndex),
        afterLink: text.substring(endIndex + 4),
        originalText: text,
      ),
      property: variable.property.copyWith(
        link: '${customData.fileBaseURL}${variable.property.link}',
      ),
    );
  }

  dynamic _toDropdownValue({
    required dynamic dtoValue,
    required List<DPAValue> availableValues,
  }) {
    if (dtoValue != null) return dtoValue;

    if (availableValues.length == 1) return availableValues.first.id;

    return dtoValue;
  }
}

DPAVariable _toFileVariable(
  DPAVariable variable,
) {
  final String value = variable.value;

  return variable.copyWith(
    value: DPAFileData(
      name: value.replaceAll('get_file/', ''),
      size: 0,
    ),
  );
}

/// Extension that provides mappings for [DPAVariable]
extension DPAVariableMapping on DPAVariable {
  /// Maps into a [DPAVariableDTO]
  DPAVariableDTO toDPAVariableDTO() => DPAVariableDTO(
        id: id,
        key: key,
        label: label,
        order: order,
        type: type.toDPATypeDTO(),
        submitType: submitType,
        value: value,
        values: availableValues.toDPAValueDTOList(),
        property: property.toDPAVariablePropertyDTO(),
      );

  // String _mapListValue() {
  //   final list = value as List<String>;
  //   return list.fold(
  //     '',
  //     (prev, value) => prev += (prev.isNotEmpty ? '|' : '') + value,
  //   );
  // }
}

/// Extension that provides mappings for lists of [DPAVariableDTO]
extension DPAVariableDTOListMapping on List<DPAVariableDTO> {
  /// Maps into a list of [DPAVariable]
  List<DPAVariable> toDPAVariableList(DPAMappingCustomData customData) => map(
        (e) => e.toDPAVariable(customData),
      ).toList().sortByOrder();
}

/// Extension that provides mappings for lists of [DPAVariable]
extension DPAVariableListMapping on Iterable<DPAVariable> {
  /// Maps into a list of [DPAVariableDTO]
  List<DPAVariableDTO> toDPAVariableDTOList() =>
      map((e) => e.toDPAVariableDTO()).toList();

  /// Maps into a map of <`String`, [DPAVariableDTO]>, using the variable key,
  /// and, if that is not supplied, the id as the map key.
  Map<String, DPAVariableDTO> toDPAVariableDTOMap() {
    final result = <String, DPAVariableDTO>{};

    where(
      (e) => (e.key.isNotEmpty || e.id.isNotEmpty) && !e.type.shouldUploadFile,
    ).forEach(
      (e) => result[e.key.isNotEmpty ? e.key : e.id] = e.toDPAVariableDTO(),
    );

    return result;
  }
}

/// Extension that provides mappings for maps of String and [DPAVariableDTO]
extension DPAVariableDTOMapMapping on Map<String, DPAVariableDTO> {
  /// Maps into a list of [DPAVariable], using the key as id, if that is not
  /// supplied.
  List<DPAVariable> toDPAVariableList(DPAMappingCustomData customData) {
    final result = <DPAVariable>[];

    forEach(
      (k, v) => result.add(
        v.toDPAVariable(customData).copyWith(
              id: v.id ?? k,
              key: v.key ?? k,
            ),
      ),
    );

    return result.sortByOrder();
  }
}

/// Extension that provides mappings for [DPAVariableType].
extension DPAVariableTypeMapping on DPAVariableType {
  /// Maps into a [DPATypeDTO].
  DPATypeDTO toDPATypeDTO() {
    switch (this) {
      case DPAVariableType.text:
      case DPAVariableType.image:
      case DPAVariableType.signature:
      case DPAVariableType.link:
      case DPAVariableType.swipe:
      case DPAVariableType.pin:
      case DPAVariableType.textArea:
        return DPATypeDTO.string;

      case DPAVariableType.number:
      case DPAVariableType.numberSlider:
        return DPATypeDTO.long;

      case DPAVariableType.boolean:
        return DPATypeDTO.boolean;

      case DPAVariableType.dateTime:
        return DPATypeDTO.date;

      case DPAVariableType.dropdown:
      case DPAVariableType.horizontalPicker:
      case DPAVariableType.radioButton:
      case DPAVariableType.checkboxList:
      case DPAVariableType.listButton:
      case DPAVariableType.toggleList:
        return DPATypeDTO.enumType;

      case DPAVariableType.searchResults:
        return DPATypeDTO.searchResults;

      case DPAVariableType.unknown:
        return DPATypeDTO.object;

      default:
        throw MappingException(from: DPAVariableType, to: DPATypeDTO);
    }
  }
}
