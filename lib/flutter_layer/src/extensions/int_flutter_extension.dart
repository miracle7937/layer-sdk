import 'package:flutter/painting.dart';
import '../../../data_layer/data_layer.dart';

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
}
