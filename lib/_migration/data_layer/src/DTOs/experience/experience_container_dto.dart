import 'experience_setting_dto.dart';

/// Data transfer object for the experience container configured in the console.
class ExperienceContainerDTO {
  /// Unique identifier of the container.
  int? containerId;

  /// Internal name of the container as defined in the experience sheet.
  String? containerName;

  /// Title of the container.
  String? cardTitle;

  /// Code of the container type as defined in the experience sheet.
  String? typeCode;

  /// Name of the container type as defined in the experience sheet.
  String? typeName;

  /// Default order in which the containers should be displayed.
  int order = 0;

  /// Values of the experience settings included in this container.
  Map<String, dynamic> settingValues = {};

  /// Definitions of the experience settings included in this container.
  List<ExperienceSettingDTO>? settingDefinitions;

  /// Messages included in this container.
  Map<String, dynamic> messages = {};

  /// Creates a list of [ExperienceContainerDTO] from a list of json objects.
  static List<ExperienceContainerDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(ExperienceContainerDTO.fromJson).toList();

  /// Creates [ExperienceContainerDTO] from a json object.
  ExperienceContainerDTO.fromJson(Map<String, dynamic> json) {
    containerId = json['card_id'];
    containerName = json['container'];
    cardTitle = json['card_title'] ?? '';
    order = json['order'] ?? 0;
    typeCode = json['type_code'];
    typeName = json['type'];
    settingValues =
        Map<String, dynamic>.from(json['settings'] ?? <String, dynamic>{});
    messages =
        Map<String, dynamic>.from(json['messages'] ?? <String, dynamic>{});
    settingDefinitions = ExperienceSettingDTO.fromJsonList(
      json['container_settings'] ?? [],
    );
  }
}
