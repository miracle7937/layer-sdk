import '../../dtos.dart';

/// Holds the DPA values.
class DPAValueDTO {
  /// Id
  final String? id;

  /// Name
  final String? name;

  /// Icon
  final String? icon;

  /// URL to an associated image.
  final String? imageUrl;

  /// Subname.
  final String? subName;

  /// The description of this value.
  final String? description;

  /// The possible fields for this value
  final List<DPAValueFieldDTO>? fields;

  /// Creates a new [DPAValueDTO].
  DPAValueDTO({
    this.id,
    this.name,
    this.imageUrl,
    this.icon,
    this.subName,
    this.description,
    this.fields,
  });

  /// Creates a new [DPAValueDTO] from the given JSON.
  factory DPAValueDTO.fromJson(Map<String, dynamic> json) => DPAValueDTO(
        id: json['id']?.toString(),
        name: json['name'],
        imageUrl: json["image"],
        icon: json["icon"],
        subName: json["sub_name"],
        description: json["description"],
        fields: json["fields"] == null
            ? null
            : DPAValueFieldDTO.fromJsonList(
                List<Map<String, dynamic>>.from(json["fields"])),
      );

  /// Creates a list of [DPAValueDTO]s from the given list of JSONs.
  static List<DPAValueDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(DPAValueDTO.fromJson).toList();

  /// Creates a new JSON from the this [DPAValueDTO].
  Map<String, String?> toJson() => {
        "id": id,
        "name": name,
        "image": imageUrl,
        "icon": icon,
        "subName": subName,
        "description": description
      };

  /// Creates a list of JSONs from the given list [DPAValueDTO]s.
  static List<Map<String, String?>> toJsonList(List<DPAValueDTO> dpaValues) =>
      dpaValues.map((dpaValue) => dpaValue.toJson()).toList();

  @override
  String toString() => 'DPAValueDTO{'
      '${id != null ? ' id: $id' : ''}'
      '${name != null ? ' name: $name' : ''}'
      '${icon != null ? ' icon: $icon' : ''}'
      '${imageUrl != null ? ' imageUrl: $imageUrl' : ''}'
      '${subName != null ? ' subName: $subName' : ''}'
      '${description != null ? ' description: $description' : ''}'
      '}';
}
