import 'dart:ui';

import '../../domain_layer/models.dart';
import '../utils.dart';

/// UI Extension for [Resolution]
extension ResolutionUIExtension on Resolution {
  /// Maps into a `Size`.
  Size toSize() => Size(width, height);

  /// Formats the resolution into a presentable string.
  String toFormattedString(Translation translation) => translation
      .translate('resolution_value')
      .replaceAll('{width}', width.toStringAsFixed(0))
      .replaceAll('{height}', height.toStringAsFixed(0));
}
