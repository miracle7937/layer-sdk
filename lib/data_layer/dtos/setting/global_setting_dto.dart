import '../../helpers/json_parser.dart';

/// Data transfer object that represents a global console setting.
class GlobalSettingDTO {
  /// The setting id.
  int? id;

  /// The module that contains the setting.
  String? module;

  /// The setting code.
  String? code;

  /// The description of the setting.
  String? description;

  /// The setting label.
  String? label;

  /// The setting type.
  // TODO: use an enum:
  // B=Boolean, N=Numeric, S=String, O=Object
  String? type;

  /// The setting value.
  String? value;

  /// The date when the setting was created.
  DateTime? created;

  /// The date when the setting was last updated.
  DateTime? updated;

  // TODO: there is also a "status" field, let's document and add it later

  /// Creates [GlobalSettingDTO].
  GlobalSettingDTO({
    this.id,
    this.module,
    this.code,
    this.description,
    this.label,
    this.type,
    this.value,
    this.created,
    this.updated,
  });

  /// Creates [GlobalSettingDTO] from a json map.
  factory GlobalSettingDTO.fromJson(Map<String, dynamic> json) =>
      GlobalSettingDTO(
        id: json['setting_id'],
        module: json['module'],
        code: json['code'],
        description: json['description'],
        label: json['label'],
        type: json['type'],
        value: json['value'],
        created: JsonParser.parseDate(json['created']),
        updated: JsonParser.parseDate(json['updated']),
      );

  /// Creates [GlobalSettingDTO]s from json list.
  static List<GlobalSettingDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(GlobalSettingDTO.fromJson).toList();
}
