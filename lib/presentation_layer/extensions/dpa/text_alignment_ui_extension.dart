import 'dart:ui';

import '../../../domain_layer/models.dart';

/// UI extensions for the [TextAlignment].
extension TextAlignmentUIExtension on TextAlignment {
  /// Maps into a [TextAlign]
  TextAlign toTextAlign() {
    switch (this) {
      case TextAlignment.center:
        return TextAlign.center;

      case TextAlignment.left:
        return TextAlign.left;
    }
  }
}
