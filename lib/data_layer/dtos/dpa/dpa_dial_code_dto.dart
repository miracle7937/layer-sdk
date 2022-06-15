import 'dart:convert';

/// Holds the dial code information of a [DPAVariableDTO]
class DPADialCodeDTO {
  /// The dial code
  final String? dialCode;

  /// The country name
  final String? countryName;

  /// The country code
  final String? countryCode;

  /// Icon path of this [DPADialCodeDTO].
  final String? icon;

  /// Creates a new [DPADialCodeDTO] instance.
  DPADialCodeDTO({
    this.dialCode,
    this.countryName,
    this.countryCode,
    this.icon,
  });

  /// Creates a new [DPADialCodeDTO] from a map.
  factory DPADialCodeDTO.fromJson(Map<String, dynamic> json) => DPADialCodeDTO(
        dialCode: json['dial_code'] ?? '',
        countryName: json['country_name'] ?? '',
        countryCode: json['country_code'] ?? '',
        icon: json['icon'] ?? '',
      );

  /// Creates a list of [DPADialCodeDTO] from the provided list
  static List<DPADialCodeDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      List<DPADialCodeDTO>.from(
        json.map(DPADialCodeDTO.fromJson),
      );

  /// Creates a list of [DPADialCodeDTO] by decond a json string.
  static List<DPADialCodeDTO> fromStringList(String list) {
    return fromJsonList(
      List.from(json.decode(list)),
    );
  }
}
