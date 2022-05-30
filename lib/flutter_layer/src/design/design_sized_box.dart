import 'package:flutter/material.dart';

import '../design.dart';

// TODO: make it animated
/// A [SizedBox] that sets different sizes for specific [DesignSize]s.
class DesignSizedBox extends StatelessWidget {
  /// The optional child widget.
  final Widget? child;

  /// The style to use.
  ///
  /// Defaults to [DesignStyle.common].
  final DesignStyle style;

  /// If non-null, sets the default width to be used for the child.
  ///
  /// Widths defined on [sizeWidths] take precedence.
  final double? width;

  /// If non-null, sets the default height to be used for the child.
  ///
  /// Heights defined on [sizeHeights] take precedence.
  final double? height;

  /// The specific width to use for a design size.
  final Map<DesignSize, double> sizeWidths;

  /// The specific height to use for a design size.
  final Map<DesignSize, double> sizeHeights;

  /// Creates a new [DesignSizedBox].
  const DesignSizedBox({
    Key? key,
    this.child,
    this.style = DesignStyle.common,
    this.width,
    this.height,
    this.sizeWidths = const {},
    this.sizeHeights = const {},
  })  : assert(
          sizeWidths.length > 0 || sizeHeights.length > 0,
          'Use a SizedBox instead if the values do not change '
          'for specific design sizes.',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final designSize = DesignAware.of(context, style: style).size;

    return SizedBox(
      child: child,
      width: sizeWidths[designSize] ?? width,
      height: sizeHeights[designSize] ?? height,
    );
  }
}
