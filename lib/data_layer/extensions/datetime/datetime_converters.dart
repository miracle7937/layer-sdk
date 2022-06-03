import 'package:intl/intl.dart';

/// Converter extension for the `DateTime` type.
extension DateTimeConverter on DateTime {
  /// Converts to a `String` as used by the backend.
  String toDTOString({
    bool truncateHours = false,
  }) {
    if (!truncateHours) {
      return toIso8601String();
    }

    return '${DateTime(year, month, day).toIso8601String()}+0000';
  }

  /// Converts to a `String` as used by the backend.
  static DateTime? fromDTOString(String? v) =>
      v == null ? null : DateFormat('dd/MM/yyyy').parse(v);
}
