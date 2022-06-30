import 'package:flutter/painting.dart';
import '../../_migration/data_layer/data_layer.dart';

/// Convenience extensions on the `int` type
extension IntFlutterExtension on int {
  /// Transforms this integer into a color.
  Color toColor() => Color(this);

  /// Transform this integer into a FontWeight.
  FontWeight toFontWeight() {
    try {
      return FontWeight.values[(this ~/ 100) - 1];
    } on Exception {
      throw MappingException(from: int, to: FontWeight);
    }
  }

  /// Formats an `int` value into a minutes timestamp.
  ///
  /// Example:  130 would be formatted to `02:10`.
  String toMinutesTimestamp() {
    final mins = (this ~/ 60).toString();
    final secs = (this % 60).toString();

    final cleanMins = mins.length > 1 ? mins : '0$mins';
    final cleanSecs = secs.length > 1 ? secs : '0$secs';

    return '$cleanMins:$cleanSecs';
  }
}
