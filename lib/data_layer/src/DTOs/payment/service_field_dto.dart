import '../../helpers.dart';

/// Data transfer object representing Service fields
/// retrieved from the payment service.
class ServiceFieldDTO {
  /// A unique identifier for a field
  String? fieldId;

  /// The id of the service this field belongs to
  int? serviceId;

  /// The code of the service field
  String? code;

  /// The name of the service field, possibly to use as a label
  String? name;

  /// The type of the service field
  ServiceFieldDTOType? serviceFieldType;

  /// The description of the service field
  String? description;

  /// The different options of the field.
  /// This is usually in case the type is List
  List<Map<String, dynamic>>? options;

  /// This specifies if this service field is required to be filled
  /// when posting a bill
  bool? required;

  /// The default value selected of the service field
  dynamic defaultValue;

  /// Date this service field was created.
  DateTime? created;

  /// Date this service field was updated.
  DateTime? updated;

  /// Creates a new [ServiceFieldDTO]
  ServiceFieldDTO({
    this.fieldId,
    this.serviceId,
    this.code,
    this.name,
    this.serviceFieldType,
    this.description,
    this.options,
    this.required,
    this.defaultValue,
    this.created,
    this.updated,
  });

  /// Creates a [ServiceFieldDTO] from a JSON
  factory ServiceFieldDTO.fromJson(Map<String, dynamic> json) {
    return ServiceFieldDTO(
      fieldId: json['field_id']?.toString(),
      serviceId: json['service_id'],
      code: json['code'],
      name: json['name'],
      serviceFieldType: ServiceFieldDTOType(json['type']),
      description: json['description'],
      options: json['options'] != null && (json['options'] as List).isNotEmpty
          ? (json['options'] as List)
              .map((mapModel) => mapModel as Map<String, dynamic>)
              .toList()
          : [],
      required: json['required'] ?? true,
      defaultValue: json['default_value'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_Updated']),
    );
  }

  /// Creates a list of [ServiceFieldDTO] from a list of json objects.
  static List<ServiceFieldDTO> fromJsonList(List json) =>
      json.map((container) => ServiceFieldDTO.fromJson(container)).toList();
}

/// The service field type
class ServiceFieldDTOType extends EnumDTO {
  /// unknown or unsupported service field type
  static const unknown = ServiceFieldDTOType._internal('unknown');

  /// service field type is numeric
  static const numeric = ServiceFieldDTOType._internal('N');

  /// service field type is a string
  static const string = ServiceFieldDTOType._internal('S');

  /// service field type is a boolean
  static const boolean = ServiceFieldDTOType._internal('B');

  /// service field type is a date
  static const date = ServiceFieldDTOType._internal('D');

  /// service field type is a list
  static const list = ServiceFieldDTOType._internal('L');

  /// All the available service field types in a list
  static const List<ServiceFieldDTOType> values = [
    unknown,
    numeric,
    string,
    boolean,
    date,
    list,
  ];

  const ServiceFieldDTOType._internal(String value) : super.internal(value);

  /// Creates a [ServiceFieldDTOType] from a [String]
  factory ServiceFieldDTOType(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => ServiceFieldDTOType.unknown,
      );
}
