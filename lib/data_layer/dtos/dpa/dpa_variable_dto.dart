import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

/// Holds the data of a DPA variable.
class DPAVariableDTO {
  /// The variable id.
  final String? id;

  /// The key for this variable on the variables list.
  ///
  /// Set when loading a process or task that have maps for the variables.
  ///
  /// This is mainly used when uploading files to identify the variable
  /// associated with them.
  final String? key;

  /// The constraints for this variable.
  final DPAConstraintDTO? constraints;

  /// The label.
  final String? label;

  /// The order this variable should be presented.
  final int? order;

  /// The properties for this variable.
  final DPAVariablePropertyDTO? property;

  /// The id of the task associated with this variable.
  final String? taskId;

  /// The type of this variable.
  final DPATypeDTO? type;

  /// The string representation of the type as accepted by the backend.
  final String? submitType;

  /// The current value for this variable.
  final dynamic value;

  /// The list of values available for this variable.
  final List<DPAValueDTO>? values;

  /// More information about this variable value.
  final String? valueInfo;

  /// Creates a new [DPAVariableDTO].
  DPAVariableDTO({
    this.id,
    this.key,
    this.constraints,
    this.label,
    this.order,
    this.property,
    this.taskId,
    this.type,
    String? submitType,
    dynamic value,
    this.values,
    this.valueInfo,
  })  : value = type == DPATypeDTO.long &&
                property?.propertyType == PropertyTypeDTO.longSlider &&
                constraints?.max != null
            ? int.tryParse(constraints?.max ?? '')
            : value,
        submitType =
            type == DPATypeDTO.enumType ? DPATypeDTO.string.value : type?.value;

  @override
  String toString() => 'DPAVariableDTO{'
      '${id != null ? ' id: $id' : ''}'
      '${key != null ? ' key: $key' : ''}'
      '${label != null ? ' label: $label' : ''}'
      '${order != null ? ' order: $order' : ''}'
      '${type != null ? ' type: $type' : ''}'
      '${submitType != null ? ' submitType: $submitType' : ''}'
      '${value != null ? ' value: $value' : ''}'
      '${taskId != null ? ' taskId: $taskId' : ''}'
      '${property != null ? ' property: $property' : ''}'
      '${constraints != null ? ' constraints: $constraints' : ''}'
      '${values != null ? ' values: $values' : ''}'
      '}';

  /// Creates a new [DPAVariableDTO] from the given JSON.
  factory DPAVariableDTO.fromJson(
    Map<String, dynamic> json, {
    String? key,
  }) =>
      DPAVariableDTO(
        id: json['Id'],
        key: key,
        label: json['label'] as String,
        type: DPATypeDTO.fromRaw(json['type']),
        submitType: json['type'],
        order: json['order'],
        value: json['value'],
        taskId: json['taskId'],
        property: DPAVariablePropertyDTO.fromJson(json['properties']),
        constraints: DPAConstraintDTO.fromJson(json['constraints']),
        values: json['values'] == null
            ? null
            : DPAValueDTO.fromJsonList(
                List<Map<String, dynamic>>.from(json['values'])),
        valueInfo: json['valueInfo'] is String ? json['valueInfo'] : null,
      );

  /// Returns an ordered list of [DPAVariableDTO] based on the given list of
  /// JSONs.
  static List<DPAVariableDTO> fromJsonList(List<Map<String, dynamic>> json) {
    final variables = json.map(DPAVariableDTO.fromJson).toList();

    return getSortedVariables(variables);
  }

  /// Returns a map of String, [DPAVariableDTO] based on the given list of
  /// JSONs.
  static Map<String, DPAVariableDTO> fromJsonMap(Map json) => json.map(
        (k, v) => MapEntry(k, DPAVariableDTO.fromJson(v, key: k)),
      );

  /// Sorts the variables by their order.
  static List<DPAVariableDTO> getSortedVariables(
    List<DPAVariableDTO> variables,
  ) {
    variables.sort(
      // If a is null, then we return a positive number so that it's after
      // the second value.
      (a, b) => a.order == null
          ? 1
          : b.order == null
              ? -1
              : a.order!.compareTo(b.order!),
    );

    return variables;
  }

  /// Creates a new JSON from the given DPA variable.
  Map<String, dynamic> toJson() {
    var _value = value;

    final prefix = property?.prefix;
    if (isNotEmpty(prefix)) _value = '$prefix$_value';

    // TODO: add encryption to variables (think about the publicKey string).
    // if (property.encrypt) {
    //   final dictionary = {
    //     dpaVariable.id: _value,
    //   };
    //
    //   _value = RegisterService().encryptCredentials(dictionary, publicKey);
    // }

    final map = {
      'type': submitType,
      'value': _value,
    };

    if (type == DPATypeDTO.enumType) {
      map.putIfAbsent(
        'values',
        () => DPAValueDTO.toJsonList(values ?? []),
      );
    }

    return map;
  }

  /// Creates a new JSON from the given list of DPA variables.
  static dynamic toJsonList(
    List<DPAVariableDTO> variables, {
    bool removeReadOnly = true,
  }) {
    final jsonOut = {};

    for (var v in variables) {
      if (removeReadOnly && (v.constraints?.isReadOnly ?? false)) continue;

      jsonOut.putIfAbsent(
        v.id,
        () => v.toJson(),
      );
    }

    return jsonOut;
  }

  /// Creates a new JSON from the given map of DPA variables.
  static dynamic toJsonListFromMap(
    Map<String, DPAVariableDTO>? variables,
  ) {
    if (variables == null) return null;

    final filteredMap = Map<String, DPAVariableDTO>.of(variables)
      ..removeWhere(
        (key, value) => value.constraints?.isReadOnly ?? false,
      );

    return filteredMap.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
  }
}

/// Type of variable
class DPATypeDTO extends EnumDTO {
  /// String
  static const string = DPATypeDTO._('string');

  /// Long value
  static const long = DPATypeDTO._('long');

  /// Boolean
  static const boolean = DPATypeDTO._('boolean');

  /// Date/time
  static const date = DPATypeDTO._('date');

  /// Enumeration
  static const enumType = DPATypeDTO._('enum');

  /// Object
  static const object = DPATypeDTO._('object');

  /// Search results
  static const searchResults = DPATypeDTO._('search_results');

  /// Pin pad view.
  static const pin = DPATypeDTO._('pin');

  /// Returns all the values available.
  static const List<DPATypeDTO> values = [
    string,
    long,
    boolean,
    date,
    enumType,
    object,
    searchResults,
    pin,
  ];

  const DPATypeDTO._(String value) : super.internal(value);

  /// Creates a new [DPATypeDTO] from a raw text.
  static DPATypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  String toString() => 'DPAVariableTypeDTO{$value}';
}
