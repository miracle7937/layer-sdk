import 'experience_container_dto.dart';

/// Data transfer object representing a page within the application.
class ExperiencePageDTO {
  /// Page title
  String? title;

  /// Icon to be displayed in the navigation menu.
  String? icon;

  /// Order in which this page appears in the navigation menu.
  int order = 0;

  /// Experience containers associated with this page.
  List<ExperienceContainerDTO>? containers;

  /// Creates [ExperiencePageDTO] from json.
  ExperiencePageDTO.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        icon = json['icon_name'],
        order = json['order'] ?? 0,
        containers = ExperienceContainerDTO.fromJsonList(json['containers']);
}
