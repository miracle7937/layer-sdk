/// Holds the field data for [DPAValueDTO].
class DPAValueFieldDTO {
  /// The label of this field.
  final String? label;

  /// The value of this field.
  final dynamic value;

  /// Creates a new [DPAValueFieldDTO]
  const DPAValueFieldDTO({
    this.label,
    this.value,
  });

  /// Creates a new [DPAValueFieldDTO] from the supplied JSON.
  factory DPAValueFieldDTO.fromJson(Map<String, dynamic> json) =>
      DPAValueFieldDTO(
        label: json['label'],
        value: json['value'],
      );

  /// Creates a list of [DPAValueFieldDTO] from the supplied JSON list.
  static List<DPAValueFieldDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(DPAValueFieldDTO.fromJson).toList();

  @override
  String toString() => 'DPAValueFieldDTO(label: $label, value: $value)';
}
