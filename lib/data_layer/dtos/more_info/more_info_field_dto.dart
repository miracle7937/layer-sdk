/// Class used to choose fields that will be rendered in the server
/// and returned to the client as a html/image/pdf file
class MoreInfoFieldDTO {
  /// The field description
  final String? description;

  /// The label
  final String? label;

  /// The field visible value
  final String? value;

  /// The formatted value
  final String? formattedValue;

  /// Creates a [MoreInfoFieldDTO] model
  MoreInfoFieldDTO({
    this.description,
    this.label,
    this.value,
    this.formattedValue,
  });

  /// Generates a json Map from the class values
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'label': label,
      'value': value,
      'formatted_value': value,
    };
  }

  /// Creates a new [MoreInfoFieldDTO] from the json data
  factory MoreInfoFieldDTO.fromJson(Map<String, dynamic> json) {
    return MoreInfoFieldDTO(
      description: json['description'],
      label: json['label'],
      value: json['value'],
      formattedValue: json['formatted_value'],
    );
  }
}
