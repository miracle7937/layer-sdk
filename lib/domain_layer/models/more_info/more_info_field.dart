/// Class used to choose fields that will be rendered in the server
/// and returned to the client as a html/image/pdf file
class MoreInfoField {
  /// The field description
  final String description;

  /// The label
  final String label;

  /// The field visible value
  final String value;

  /// The formatted value
  final String? formattedValue;

  /// Creates a [MoreInfoField] model
  MoreInfoField({
    required this.description,
    required this.label,
    required this.value,
    this.formattedValue,
  });
}
