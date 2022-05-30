import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

/// Convenience class for handling JSONs
class JsonParser {
  /// Parses a value into a [double].
  static double? parseDouble(num? value) => value?.toDouble();

  /// Parses a value into an [int].
  static int parseInt(num? value) => (value ?? 0).toInt();

  /// Parses a value into a [DateTime].
  static DateTime? parseDate(dynamic value) {
    if (value == null || value is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  /// Parses a [String] into a [DateTime].
  static DateTime? parseStringDate(String? value) {
    if (value != null) {
      try {
        return DateTime.parse(value);
      } on Exception catch (e) {
        print('errorParsingJsonDate $e');
      }
    }
    return null;
  }

  /// Encodes a list of [int] into a [String].
  String base64Encode(List<int> bytes) => base64.encode(bytes);

  /// Decodes a [String] into a list of [int].
  Uint8List base64Decode(String source) => base64.decode(source);

  /// Format date object into a formatted date
  static String parseDateWithPattern(
    DateTime date,
    String pattern,
    String locale,
  ) {
    return DateFormat(pattern, locale).format(date);
  }
}

///
R? jsonLookup<R, K>(Map<K, dynamic>? map, Iterable<K> keys, [R? defaultValue]) {
  if (map == null) return null;

  dynamic value = map;
  for (final key in keys) {
    if (value is Map<K, dynamic> && value.containsKey(key)) {
      value = value[key];
    } else {
      return defaultValue;
    }
  }
  return value as R;
}
