import 'package:equatable/equatable.dart';

/// Keeps the data of a service field
class ServiceField extends Equatable {
  /// A unique identifier for a field
  final String fieldId;

  /// The id of the service this field belongs to
  final int? serviceId;

  /// The code of the service field
  final String code;

  /// The name of the service field, possibly to use as a label
  final String name;

  /// The type of the service field
  final ServiceFieldType serviceFieldType;

  /// The description of the service field
  final String? description;

  /// The different options of the field.
  /// This is usually in case the type is List
  final List<Map<String, dynamic>>? options;

  /// This specifies if this service field is required to be filled
  /// when posting a bill
  final bool required;

  /// The default value selected of the service field
  final dynamic defaultValue;

  /// Date this service field was created.
  final DateTime? created;

  /// Date this service field was updated.
  final DateTime? updated;

  /// The value selected for the service field
  final String? value;

  /// Creates a new [ServiceField]
  ServiceField({
    required this.fieldId,
    required this.serviceId,
    required this.code,
    required this.name,
    this.required = false,
    this.serviceFieldType = ServiceFieldType.unknown,
    this.description,
    this.options,
    this.defaultValue,
    this.created,
    this.updated,
    this.value,
  });

  @override
  List<Object?> get props => [
        fieldId,
        serviceId,
        code,
        name,
        required,
        serviceFieldType,
        description,
        options,
        defaultValue,
        created,
        updated,
        value,
      ];

  /// Creates a copy of this service field with different values
  ServiceField copyWith({
    String? fieldId,
    int? serviceId,
    String? code,
    String? name,
    bool? required,
    ServiceFieldType? serviceFieldType,
    String? description,
    List<Map<String, dynamic>>? options,
    dynamic defaultValue,
    DateTime? created,
    DateTime? updated,
    String? value,
  }) {
    return ServiceField(
      fieldId: fieldId ?? this.fieldId,
      serviceId: serviceId ?? this.serviceId,
      code: code ?? this.code,
      name: name ?? this.name,
      required: required ?? this.required,
      serviceFieldType: serviceFieldType ?? this.serviceFieldType,
      description: description ?? this.description,
      options: options ?? this.options,
      defaultValue: defaultValue ?? this.defaultValue,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      value: value ?? this.value,
    );
  }
}

/// The service field type
enum ServiceFieldType {
  /// unknown or unsupported service field type
  unknown,

  /// service field type is numeric
  numeric,

  /// service field type is a string
  string,

  /// service field type is a boolean
  boolean,

  /// service field type is a date
  date,

  /// service field type is a list
  list,
}
