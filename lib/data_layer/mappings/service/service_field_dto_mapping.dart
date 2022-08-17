import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [ServiceFieldDTO]
extension ServiceFieldsDTOMapping on ServiceFieldDTO {
  /// Maps into a [ServiceField]
  ServiceField toServiceField() {
    return ServiceField(
      fieldId: fieldId ?? 0,
      serviceId: serviceId,
      code: code ?? '',
      name: name ?? '',
      required: required ?? false,
      serviceFieldType:
          serviceFieldType?.toServiceFieldType() ?? ServiceFieldType.unknown,
      description: description,
      options: options,
      defaultValue: defaultValue,
      created: created,
      updated: updated,
      value: value,
    );
  }
}

/// Extension that provides mappings for [ServiceFieldDTOType]
extension ServiceFieldDTOTypeMapping on ServiceFieldDTOType {
  /// Maps into a [ServiceFieldType]
  ServiceFieldType toServiceFieldType() {
    switch (this) {
      case ServiceFieldDTOType.boolean:
        return ServiceFieldType.boolean;

      case ServiceFieldDTOType.date:
        return ServiceFieldType.date;

      case ServiceFieldDTOType.list:
        return ServiceFieldType.list;

      case ServiceFieldDTOType.numeric:
        return ServiceFieldType.numeric;

      case ServiceFieldDTOType.string:
        return ServiceFieldType.string;

      default:
        return ServiceFieldType.unknown;
    }
  }
}

/// Extension that provides mappings for [ServiceField]
extension ServiceFieldsToDTOMapping on ServiceField {
  /// Maps into a [ServiceFieldDTO]
  ServiceFieldDTO toServiceFieldDTO() {
    return ServiceFieldDTO(
      fieldId: fieldId,
      serviceId: serviceId,
      code: code,
      name: name,
      required: required,
      serviceFieldType: serviceFieldType.toServiceFieldDTOType(),
      description: description,
      options: options,
      defaultValue: defaultValue,
      created: created,
      updated: updated,
      value: value,
    );
  }
}

/// Extension that provides mappings for [ServiceFieldType]
extension ServiceFieldToDTOTypeMapping on ServiceFieldType {
  /// Maps into a [ServiceFieldDTOType]
  ServiceFieldDTOType toServiceFieldDTOType() {
    switch (this) {
      case ServiceFieldType.boolean:
        return ServiceFieldDTOType.boolean;

      case ServiceFieldType.date:
        return ServiceFieldDTOType.date;

      case ServiceFieldType.list:
        return ServiceFieldDTOType.list;

      case ServiceFieldType.numeric:
        return ServiceFieldDTOType.numeric;

      case ServiceFieldType.string:
        return ServiceFieldDTOType.string;

      default:
        return ServiceFieldDTOType.unknown;
    }
  }
}
