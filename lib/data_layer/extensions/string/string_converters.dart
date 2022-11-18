import '../../../domain_layer/models.dart';

/// Converter extension for the type String
extension StringConverter on String {
  /// Parses the `String` that follows the format "123x431" into a [Resolution]
  Resolution? toResolution() {
    if (isEmpty) return null;

    final members = toLowerCase().split('x');

    if (members.length != 2) return null;

    final x = double.tryParse(members[0].trim());
    final y = double.tryParse(members[1].trim());

    if (x == null && y == null) return null;

    return Resolution(x ?? 0.0, y ?? 0.0);
  }

  /// Parses the `String` into a `DateTime`.
  DateTime? toDate() => isEmpty ? null : DateTime.parse(this);

  /// Parses the `String` that has a hexadecimal color value into an int value
  /// that can be used to generate a Color.
  int? parseHexValueToInt() =>
      isEmpty ? null : int.tryParse(replaceAll('#', ''), radix: 16);
}
